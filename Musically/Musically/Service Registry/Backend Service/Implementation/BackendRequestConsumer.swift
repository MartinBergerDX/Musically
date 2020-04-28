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
        
        // We are doing sync dispatch here to block thread spawned by OperationQueue for our Operation
        // Otherwise we would have to use AsyncOperation subclass of Operation
        let semaphore = DispatchSemaphore(value: 0)
        session.dataTask(with: urlRequest) { [unowned self] (data, response, error) in
            backendRequest.set(requestState: error == nil ? .finished : .failed)
            backendRequest.set(result: self.makeResult(data: data, error: error))
            backendRequest.onComplete()
            DispatchQueue.main.async {
                backendRequest.executeCommands()
                semaphore.signal() // Request completes [C]
            }
            self.printRequest(backendRequest: backendRequest, error: error)
        }.resume()
        // Waits for request to complete [C]
        _ = semaphore.wait(timeout: DispatchTime.now() + serviceConfiguration.defaultTimeout)
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
        var components = URLComponents.init(url: URL.init(string: serviceConfiguration.baseUrl)!, resolvingAgainstBaseURL: true)!
        var queryItems = [URLQueryItem(name: "method", value: request.endpoint),
                          URLQueryItem(name: "api_key", value: serviceConfiguration.APIKey),
                          URLQueryItem(name: "format", value: "json")]
        queryItems.append(contentsOf: request.argumentList())
        components.queryItems = queryItems
        return components.url ?? URL.init(string: "url.not.formed")!
    }
    
    private func setupDefaultSession() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = serviceConfiguration.defaultTimeout
        configuration.timeoutIntervalForResource = serviceConfiguration.defaultTimeout
        session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue())
    }
}
