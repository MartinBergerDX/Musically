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
}

protocol BackendRequestProtocol: BackendRequestAttributesProtocol, BackendRequestServiceControlProtocol {
    
}

enum BackendRequestState: Int {
    case ready
    case executing
    case failed
    case finished
}

//protocol BackendRequestDataType: Decodable, Initable {
//
//}

class BackendRequest<T: Decodable & Initable>: BackendOperation, BackendRequestProtocol {
    var commands: [BackendRequestCommandProtocol]
    var requestResult: Result<Data, Error>!
    var endpoint: String
    var arguments: [URLQueryItem]
    var method: String
    var pagination: RequestPaging
    var state: BackendRequestState {
        didSet {
            onStateChange()
        }
    }
    private (set) var value: T!

    override func main() {
        execution.execute(backendRequest: self)
    }
    
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
    
    func executeCommands() {
        for command in commands {
            command.execute(request: self)
        }
    }
    
    func argumentList() -> [URLQueryItem] {
        return arguments + pagination.arguments()
    }
    
    func mapJson() {
        guard let data: Data = try? requestResult.get() else {
            return
        }
        do {
            value = try mappedJson(from: data)
        } catch let decodingError {
            value = T.init()
            requestResult = Result.failure(decodingError)
        }
    }
    
    func mappedJson(from data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func onStateChange() {
        
    }
    
    // MARK: BackendRequestServiceControlProtocol
    
    func set(requestState: BackendRequestState) {
        state = requestState
    }
    
    func set(result: Result<Data, Error>) {
        requestResult = result
    }
    
    func onComplete() {
        mapJson()
        executeCommands()
        finishOperation()
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

protocol BackendRequestCommandProtocol {
    func execute<T: Decodable & Initable>(request: BackendRequest<T>)
}

class BackendRequestCompletionCommand: BackendRequestCommandProtocol {
    var completion: (() -> Void)!
    
    init(callback: @escaping () -> Void) {
        self.completion = callback
    }
    
    func execute<T>(request: BackendRequest<T>) {
        completion()
    }
}

class BackendRequestResultCommand<DataType: Decodable & Initable>: BackendRequestCommandProtocol {
    
    var completion: ((DataType) -> Void)?
    var failure: ((Error) -> Void)?

    func execute<T: Decodable & Initable>(request: BackendRequest<T>) {
//        if let obj: DataType = request.value as? DataType {
//            completion?(obj)
//        } else if case .failure(let error) = request.requestResult {
//            failure?(error)
//        }
        if case .failure(let error) = request.requestResult {
            failure?(error)
            return
        }
        completion?(request.value as! DataType)
    }
}
