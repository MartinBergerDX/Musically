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
    var database: CoreDataStack {get}
    var backendService: BackendServiceProtocol {get}
}

class ServiceRegistry : ServiceRegistryProtocol {
    static let shared = ServiceRegistry.init()
    let database = CoreDataStack.init(modelName: CoreDataStack.defaultModelName)
    let backendService: BackendServiceProtocol = BackendService.init(serviceConfiguration: BackendServiceConfiguration())
    let imageCache = NSCache<NSString, UIImage>.init()
}
