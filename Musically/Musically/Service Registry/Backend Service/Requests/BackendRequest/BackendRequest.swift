//
//  BackendRequest.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

// wrapper around endpoint string, http method and arguments
// when making a call to server, instantiate BackendRequest class

protocol BackendRequestProtocol {
    var endpoint: String {get}
    var arguments: String {get}
    var method: String {get}
    var state: BackendRequestState {get set}
    func set(requestState: BackendRequestState)
    func onComplete(result: Result<Data,Error>)
    func argumentList() -> String
}

enum BackendRequestState: Int {
    case ready
    case failed
    case finished
    case executing
}

class BackendRequest: BackendRequestProtocol {
    var endpoint: String
    var arguments: String
    var method: String
    var pagination: RequestPaging
    var state: BackendRequestState
    
    func set(requestState: BackendRequestState) {
        self.state = requestState
    }
    
    func onComplete(result: Result<Data,Error>) {
        fatalError()
    }
    
    init () {
        endpoint = "not set"
        arguments = ""
        method = HTTPMethod.get.rawValue
        pagination = RequestPaging.null
        state = .ready
    }
    
    func argumentList() -> String {
        return arguments + pagination.arguments()
    }
}
