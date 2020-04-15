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
    var imageCache: ImageCacheProtocol {get}
}

class ServiceRegistry : ServiceRegistryProtocol {
    static let shared: ServiceRegistry = { ServiceRegistry.init() }()
    var factory: ServiceFactoryProtocol = ProductionServiceFactory()
    
    let database: DatabaseProtocol
    let backendService: BackendServiceProtocol
    let imageCache: ImageCacheProtocol
    
    init() {
        database = factory.produceDatabase()
        backendService = factory.produceBackendService()
        imageCache = factory.produceImageCache()
    }
}
