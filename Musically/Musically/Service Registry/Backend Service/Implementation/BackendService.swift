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
    var requestExecutor: BackendRequestExecutor! {get}
    var scheduler: BackendServiceScheduler! {get}
    func schedule(backendRequest: BackendRequest)
}

class BackendService: BackendServiceProtocol {
    let requestExecutor: BackendRequestExecutor!
    let scheduler: BackendServiceScheduler!
    
    init(requestExecutor: BackendRequestExecutor!, scheduler: BackendServiceScheduler!) {
        self.requestExecutor = requestExecutor
        self.scheduler = scheduler
    }
    
    func schedule(backendRequest: BackendRequest) {
        scheduler.enqueue(request: backendRequest)
    }
}
