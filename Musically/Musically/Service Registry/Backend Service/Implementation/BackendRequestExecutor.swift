//
//  BackendRequestExecutor.swift
//  Musically
//
//  Created by Martin on 2/7/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation

protocol BackendRequestExecutorProtocol: class {
    func execute(backendRequest:  BackendRequestProtocol)
}

class BackendRequestExecutor {
    private var session: URLSession!
    private let serviceConfiguration: BackendServiceConfiguration!
    
    init(serviceConfiguration: BackendServiceConfiguration) {
        self.serviceConfiguration = serviceConfiguration
        setupDefaultSession()
    }
    
    func execute(backendRequest:  BackendRequestProtocol) {
        let full: String = urlString(request: backendRequest)
        let url = URL.init(string: full)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = backendRequest.method
        urlRequest.addValue(serviceConfiguration.userAgent.UAString(), forHTTPHeaderField: "User-Agent")
        
        print("Making request:")
        print(backendRequest)
        print(urlRequest)
        
        backendRequest.set(requestState: .ready)
        
        session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async(execute: { () -> Void in
                guard error == nil else {
                    print("Request completed with errors.")
                    backendRequest.onComplete(result: .failure(error!))
                    backendRequest.set(requestState: .failed)
                    return
                }
                print("Request completed.")
                let received: Data = data ?? Data.init()
                backendRequest.onComplete(result: .success(received))
                backendRequest.set(requestState: .finished)
            })
        }.resume()
    }
    
    private func urlString(request: BackendRequestProtocol) -> String {
        let join = "&"
        var url = serviceConfiguration.baseEndpoint
        url.append("?")
        url.append("method=")
        url.append(request.endpoint)
        url.append(join)
        url.append(request.argumentList())
        url.append(join)
        url.append("api_key=")
        url.append(serviceConfiguration.APIKey)
        url.append(join)
        url.append("format=json")
        return url
    }
    
    private func setupDefaultSession() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = serviceConfiguration.defaultTimeout
        configuration.timeoutIntervalForResource = serviceConfiguration.defaultTimeout
        session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
    }
}
