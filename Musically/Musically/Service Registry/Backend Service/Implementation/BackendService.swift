//
//  BackendService.swift
//  Musically
//
//  Created by Martin on 9/25/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

// martin-345
// martin.berger.developer@gmail.com
// KQ65-6E5H-5F5G-BKXF-XGH54

import Foundation

protocol BackendServiceProtocol: class {
    func execute(backendRequest:  BackendRequestProtocol)
    func enqueue(backendRequest: BackendRequestProtocol)
    var serialExecution: BackendServiceSerialExecution! {get}
}

class BackendService: BackendServiceProtocol {
    private var session: URLSession!
    private let serviceConfiguration: BackendServiceConfiguration!
    private(set) var serialExecution: BackendServiceSerialExecution!
    
    init(serviceConfiguration: BackendServiceConfiguration) {
        self.serialExecution = BackendServiceSerialExecution()
        self.serviceConfiguration = serviceConfiguration
        setupDefaultSession()
    }
    
    func enqueue(backendRequest: BackendRequestProtocol) {
        let op = BackendOperation.init()
        op.backendService = self
        op.backendRequest = backendRequest
        serialExecution.enqueue(request: op)
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
