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

class BackendRequest: BackendOperation, BackendRequestProtocol {
    var endpoint: String
    var arguments: String
    var method: String
    var pagination: RequestPaging
    var state: BackendRequestState {
        didSet {
            onStateChange()
        }
    }

    func set(requestState: BackendRequestState) {
        self.state = requestState
    }
    
    func onComplete(result: Result<Data,Error>) {
        fatalError()
    }
    
    override
    init () {
        endpoint = "you need to set endpoint in derived class"
        arguments = String()
        method = HTTPMethod.get.rawValue
        pagination = RequestPaging.Null
        state = .ready
        super.init()
    }
    
    func argumentList() -> String {
        return arguments + pagination.arguments()
    }
    
    private func onStateChange() {
        switch state {
            case .finished, .failed:
                finish()
            default:
                break
            }
    }
    
    override func main() {
        backendRequestExecution.execute(backendRequest: self)
    }
}

func calculateReplaceRange(page: Int, count: Int) -> ClosedRange<Int> {
    let zeroBasedArrayOffset: Int = 1
    let nElementsMoreMinusOne: Int = (count - 1)
    let pageOffset: Int = (page - zeroBasedArrayOffset)
    let startArrayIndex: Int = (pageOffset * count)
    let endArrayIndex: Int = (startArrayIndex + nElementsMoreMinusOne)
    return startArrayIndex...endArrayIndex
}
