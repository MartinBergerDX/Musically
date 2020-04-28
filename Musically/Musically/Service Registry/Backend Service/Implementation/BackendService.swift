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
    func enqueue(request: BackendOperation)
    func enqueue(requests: [BackendOperation])
}

class BackendService: BackendServiceProtocol {
    internal var requestQueue: OperationQueue!
    private let consumer: BackendRequestConsumerProtocol!
    
    init(consumer: BackendRequestConsumerProtocol!) {
        self.consumer = consumer
        setupRequestQueue()
    }
    
    func setupRequestQueue() {
        requestQueue = OperationQueue()
        requestQueue.name = "Backend Service request concurrent queue"
        requestQueue.maxConcurrentOperationCount = 10
        requestQueue.underlyingQueue = DispatchQueue.global()
    }
    
    func enqueue(request: BackendOperation) {
        request.execution = consumer
        requestQueue.addOperation(request)
    }
    
    func enqueue(requests: [BackendOperation]) {
        var _ = requests.map({ $0.execution = self.consumer })
        requestQueue.addOperations(requests, waitUntilFinished: false)
    }
    
    func enqueueAll(requests: [BackendOperation], completion: @escaping () -> Void) {
        let completion = BlockOperation.init(block: completion)
        for request in requests {
            request.execution = consumer
            completion.addDependency(request)
        }
        var operations: [Operation] = requests.map({ $0 as BackendOperation })
        operations.append(completion)
        requestQueue.addOperations(operations, waitUntilFinished: false)
    }
    
    func requestIterator() -> BackendRequestIterator {
        if let operations = requestQueue.operations as? [BackendRequestAttributesProtocol] {
            let iterator = operations.makeIterator()
            return BackendRequestIterator.init(iterator: iterator)
        }
        return BackendRequestIterator.null
    }
    
    func currentOperationCount() -> Int {
        return requestQueue.operationCount
    }
}
