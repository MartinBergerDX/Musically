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
    private var session: URLSession! = URLSession.init()
    private let APIKey: String = "4ada9c636666c2d26556850f10f59121"
    private let sharedSecret: String = "a6c18927ef5d6771e18b76db9bceffda"
    private let baseEndpoint: String = "http://ws.audioscrobbler.com/2.0/"
    private let userAgent: UserAgent = UserAgent()
    private let defaultTimeout: TimeInterval = 10
    
    init() {
        setupDefaultSession()
    }
    
    func execute(request: BackendRequest) {
        let full: String = urlString(request: request)
        let url = URL.init(string: full)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method
        urlRequest.addValue(self.userAgent.UAString(), forHTTPHeaderField: "User-Agent")
        session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                request.onComplete(result: .failure(error!))
                return
            }
            let received: Data = data ?? Data.init()
            request.onComplete(result: .success(received))
        }.resume()
    }
    
    private func urlString(request: BackendRequest) -> String {
        let join = "&"
        var url = self.baseEndpoint
        url.append("?")
        url.append("method=")
        url.append(request.endpoint)
        url.append(join)
        url.append(request.arguments)
        url.append(join)
        url.append("api_key=")
        url.append(APIKey)
        url.append(join)
        url.append("format=json")
        return url
    }
    
    private func setupDefaultSession() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = self.defaultTimeout
        configuration.timeoutIntervalForResource = self.defaultTimeout
        session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
    }
}
