//
//  ServiceRegistry.swift
//  Musically
//
//  Created by Martin on 9/25/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation
import UIKit

protocol ServiceRegistryProtocol {
    var database: DatabaseProtocol {get}
    var backendService: BackendServiceProtocol {get}
}

class ServiceRegistry : ServiceRegistryProtocol {
    static let shared = ServiceRegistry.init()
    
    let database: DatabaseProtocol
    let backendService: BackendServiceProtocol
    let imageCache: NSCache<NSString, UIImage>
    
    init() {
        database = CoreDataStack.init(modelName: CoreDataStack.defaultModelName)
        let backendRequestExecutor = BackendRequestExecutor.init(serviceConfiguration: BackendServiceConfiguration())
        let backendServiceScheduler = BackendServiceScheduler.init(backendRequestExecutor: backendRequestExecutor)
        backendService = BackendService.init(requestExecutor: backendRequestExecutor, scheduler: backendServiceScheduler)
        imageCache = NSCache<NSString, UIImage>.init()
    }
}
