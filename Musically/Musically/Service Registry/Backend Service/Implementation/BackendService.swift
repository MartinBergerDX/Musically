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
}

class BackendService: BackendServiceProtocol {
    private let requestQueue: OperationQueue!
    private let backendRequestExecution: BackendRequestExecution!
    
    init(backendRequestExecution: BackendRequestExecution!) {
        self.backendRequestExecution = backendRequestExecution
        requestQueue = OperationQueue.init()
        requestQueue.name = "Backend Service request serial queue"
        requestQueue.maxConcurrentOperationCount = 5
        requestQueue.underlyingQueue = DispatchQueue.global()
    }
    
    func enqueue(request: BackendOperation) {
        request.backendRequestExecution = backendRequestExecution
        requestQueue.addOperation(request)
    }
    
    func requestIterator() -> BackendRequestIterator {
        let iterator = requestQueue.operations.makeIterator()
        return BackendRequestIterator.init(iterator: iterator)
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
