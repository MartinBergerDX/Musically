//
//  BackendRequestExecution.swift
//  Musically
//
//  Created by Martin on 2/7/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation

protocol BackendRequestConsumerProtocol: class {
    func execute(backendRequest:  BackendRequestProtocol)
}

class BackendRequestConsumer: BackendRequestConsumerProtocol {
    private var session: URLSession!
    private let serviceConfiguration: BackendServiceConfiguration!
    
    init(serviceConfiguration: BackendServiceConfiguration) {
        self.serviceConfiguration = serviceConfiguration
        setupDefaultSession()
    }
    
    func execute(backendRequest:  BackendRequestProtocol) {
        let url: URL = fullUrl(request: backendRequest)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = backendRequest.method
        urlRequest.addValue(serviceConfiguration.userAgent.UAString(), forHTTPHeaderField: "User-Agent")
        
        print("Making request:")
        print(backendRequest)
        print(urlRequest)
        
        backendRequest.set(requestState: .executing)
        
        session.dataTask(with: urlRequest) { [unowned self] (data, response, error) in
            self.printRequest(backendRequest: backendRequest, error: error)
            backendRequest.set(requestState: error == nil ? .finished : .failed)
            backendRequest.set(result: self.makeResult(data: data, error: error))
            backendRequest.onComplete()
        }.resume()
    }
    
    func makeResult(data: Data?, error: Error?) -> Result<Data, Error> {
        return error == nil ? .success(data!) : .failure(error!)
    }
    
    private func printRequest(backendRequest: BackendRequestProtocol, error: Error?) {
        print(backendRequest)
        if error == nil {
            print("Request completed.")
        } else {
            print("Request completed with error:")
            print(error!)
        }
    }
    
    private func fullUrl(request: BackendRequestProtocol) -> URL {
//        let join = "&"
//        var url = serviceConfiguration.baseUrl
//        url.append("?")
//        url.append("method=")
//        url.append(request.endpoint)
//        url.append(join)
//        url.append(request.argumentList())
//        url.append(join)
//        url.append("api_key=")
//        url.append(serviceConfiguration.APIKey)
//        url.append(join)
//        url.append("format=json")
        
        var components = URLComponents.init(url: URL.init(string: serviceConfiguration.baseUrl)!, resolvingAgainstBaseURL: true)!
        var queryItems = [URLQueryItem(name: "method", value: request.endpoint),
                          URLQueryItem(name: "api_key", value: serviceConfiguration.APIKey),
                          URLQueryItem(name: "format", value: "json")]
        queryItems.append(contentsOf: request.argumentList())
        components.queryItems = queryItems
        return components.url ?? URL.init(string: "url.not.formed")!
        
//        return url
    }
    
    private func setupDefaultSession() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = serviceConfiguration.defaultTimeout
        configuration.timeoutIntervalForResource = serviceConfiguration.defaultTimeout
        session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
    }
}
