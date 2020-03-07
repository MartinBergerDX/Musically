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
    func requestIterator() -> BackendRequestIterator
    func enqueue(request: BackendRequestProtocol)
    func enqueue(requests: [BackendRequestProtocol])
}

class BackendService: BackendServiceProtocol {
    internal let requestQueue: OperationQueue!
    private let backendRequestExecution: BackendRequestExecutionProtocol!
    
    init(backendRequestExecution: BackendRequestExecutionProtocol!) {
        self.backendRequestExecution = backendRequestExecution
        requestQueue = OperationQueue.init()
        requestQueue.name = "Backend Service request serial queue"
        requestQueue.maxConcurrentOperationCount = 5
        requestQueue.underlyingQueue = DispatchQueue.global()
    }
    
    func enqueue(request: BackendRequestProtocol) {
        requestQueue.addOperation(operationFrom(request: request))
    }
    
    func enqueue(requests: [BackendRequestProtocol]) {
        for request in requests {
            requestQueue.addOperation(operationFrom(request: request))
        }
    }
    
    func enqueueAll(requests: [BackendRequestProtocol], completion: @escaping () -> Void) {
        var operations: [Operation] = requests.map { operationFrom(request: $0) }
        operations.append(BlockOperation.init(block: completion))
        requestQueue.addOperations(operations, waitUntilFinished: false)
    }
    
    func requestIterator() -> BackendRequestIterator {
        let iterator = requestQueue.operations.makeIterator()
        return BackendRequestIterator.init(iterator: iterator)
    }
    
    private func operationFrom(request: BackendRequestProtocol) -> BackendOperation {
        let operation = BackendOperation()
        operation.backendRequest = request
        operation.execution = backendRequestExecution
        bindStatePropagation(operation: operation, request: request)
        return operation
    }
    
    private func bindStatePropagation(operation: BackendOperation, request: BackendRequestProtocol) {
        request.set(stateChangeCallback: { [unowned operation] (newState: BackendRequestState) in if newState == .finished { operation.finish() } })
    }
}

class BackendRequestIterator {
    var iterator: IndexingIterator<[Operation]>
    init(iterator: IndexingIterator<[Operation]>) {
        self.iterator = iterator
    }
    func next() -> Operation? {
        return iterator.next()
    }
    
    // Null-Object pattern
    static let null: BackendRequestIterator = {
        let it = IndexingIterator<[Operation]>(_elements: [])
        return BackendRequestIterator.init(iterator: it)
    }()
}
