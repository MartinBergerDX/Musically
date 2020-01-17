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

protocol BackendServiceProtocol {
    func execute(request: BackendRequest)
}

class BackendService: BackendServiceProtocol {
    private var session: URLSession!
    private let serviceConfiguration: BackendServiceConfiguration!
    
    init(serviceConfiguration: BackendServiceConfiguration) {
        self.serviceConfiguration = serviceConfiguration
        setupDefaultSession()
    }
    
    func execute(request: BackendRequest) {
        let full: String = urlString(request: request)
        let url = URL.init(string: full)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method
        urlRequest.addValue(serviceConfiguration.userAgent.UAString(), forHTTPHeaderField: "User-Agent")
        
        print("Making request")
        print(request)
        print(urlRequest)
        
        session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async(execute: {() -> Void in
                print("Request complete")
                guard error == nil else {
                    request.onComplete(result: .failure(error!))
                    return
                }
                let received: Data = data ?? Data.init()
                request.onComplete(result: .success(received))
            })
        }.resume()
    }
    
    private func urlString(request: BackendRequest) -> String {
        let join = "&"
        var url = serviceConfiguration.baseEndpoint
        url.append("?")
        url.append("method=")
        url.append(request.endpoint)
        url.append(join)
        url.append(request.arguments)
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
