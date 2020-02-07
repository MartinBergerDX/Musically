//
//  BackendServiceSerialExecution.swift
//  Musically
//
//  Created by Martin on 1/19/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation

class BackendServiceSerialExecution {
    private let serialRequestQueue: OperationQueue!
    
    init() {
        serialRequestQueue = OperationQueue.init()
        serialRequestQueue.name = "Backend Service request serial queue"
        serialRequestQueue.maxConcurrentOperationCount = 1
        serialRequestQueue.underlyingQueue = DispatchQueue.global()
    }
    
    func enqueue(request: BackendOperation) {
        serialRequestQueue.addOperation(request)
    }
    
    func isArtistSearchInProgress() -> Bool {
        return serialRequestQueue.operations.filter { ($0 as! BackendOperation).backendRequest is ArtistSearchRequest }.count > 0
    }
}
