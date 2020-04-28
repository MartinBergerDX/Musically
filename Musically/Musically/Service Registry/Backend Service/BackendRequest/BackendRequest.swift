//
//  BackendRequest.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

// Facade around endpoint string, http method and arguments
// when making a call to server, instantiate subclass of BackendRequest class

protocol BackendRequestCommandProtocol {
    func execute<T: Decodable & Initable>(request: BackendRequest<T>)
}

protocol BackendRequestAttributesProtocol {
    var endpoint: String {get}
    var arguments: [URLQueryItem] {get}
    var method: String {get}
    var state: BackendRequestState {get set}
    var pagination: RequestPaging {get}
    func argumentList() -> [URLQueryItem]
    func add(command: BackendRequestCommandProtocol)
}

protocol BackendRequestServiceControlProtocol {
    func set(requestState: BackendRequestState)
    func set(result: Result<Data, Error>)
    func onComplete()
    func executeCommands()
}

protocol BackendRequestProtocol: BackendRequestAttributesProtocol, BackendRequestServiceControlProtocol {
    
}

enum BackendRequestState: Int {
    case ready
    case executing
    case failed
    case finished
}

class BackendRequest<T: Decodable & Initable>: BackendOperation, BackendRequestProtocol {
    var commands: [BackendRequestCommandProtocol]
    var result: Result<Data, Error>!
    var endpoint: String
    var arguments: [URLQueryItem]
    var method: String
    var pagination: RequestPaging
    var state: BackendRequestState {
        didSet {
            onStateChange()
        }
    }
    var value: T!

    override init () {
        commands = []
        endpoint = ""
        arguments = []
        method = HTTPMethod.get.rawValue
        pagination = RequestPaging.init()
        state = .ready
        super.init()
    }
    
    func add(command: BackendRequestCommandProtocol) {
        commands.append(command)
    }
    
    func argumentList() -> [URLQueryItem] {
        return arguments + pagination.arguments()
    }
    
    func onStateChange() {
        
    }
    
    // MARK: BackendRequestServiceControlProtocol
    
    func set(requestState: BackendRequestState) {
        state = requestState
    }
    
    func set(result: Result<Data, Error>) {
        self.result = result
    }
    
    func onComplete() {
        mapJson()
    }
    
    func mapJson() {
        guard let data: Data = try? result.get() else {
            return
        }
        do {
            value = try mappedJson(from: data)
        } catch let decodingError {
            value = T.init()
            result = Result.failure(decodingError)
        }
    }
    
    func mappedJson(from data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func executeCommands() {
        for command in commands {
            command.execute(request: self)
        }
    }
    
    // MARK: Command Factory
    // Factory Method pattern
    
    func makeCompletionCommand(success: @escaping ((T) -> Void), failure: @escaping ((Error) -> Void)) -> BackendRequestResultCommand<T> {
        let command = BackendRequestResultCommand<T>.init()
        command.completion = success
        command.failure = failure
        return command
    }
}
