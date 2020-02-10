//
//  BackendServiceSerialExecution.swift
//  Musically
//
//  Created by Martin on 1/19/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation

class BackendServiceScheduler {
    private let requestQueue: OperationQueue!
    private let backendRequestExecutor: BackendRequestExecutor!
    
    init(backendRequestExecutor: BackendRequestExecutor!) {
        self.backendRequestExecutor = backendRequestExecutor
        requestQueue = OperationQueue.init()
        requestQueue.name = "Backend Service request serial queue"
        requestQueue.maxConcurrentOperationCount = 5
        requestQueue.underlyingQueue = DispatchQueue.global()
    }
    
    func enqueue(request: BackendOperation) {
        request.backendRequestExecutor = backendRequestExecutor
        requestQueue.addOperation(request)
    }
    
    func isArtistSearchInProgress() -> Bool {
        return requestQueue.operations.filter { $0 is ArtistSearchRequest }.count > 0
    }
}
