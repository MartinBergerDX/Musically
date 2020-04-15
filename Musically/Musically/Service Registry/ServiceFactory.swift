//
//  ServiceFactory.swift
//  Musically
//
//  Created by Martin on 2/12/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation
import UIKit

protocol ServiceFactoryProtocol {
    func produceDatabase() -> DatabaseProtocol
    func produceBackendService() -> BackendServiceProtocol
    func produceImageCache() -> ImageCacheProtocol
}

// Abstract Factory pattern
class ProductionServiceFactory: ServiceFactoryProtocol {
    func produceDatabase() -> DatabaseProtocol {
        return CoreDataStack.init(modelName: CoreDataStack.defaultModelName)
    }
    
    func produceBackendService() -> BackendServiceProtocol {
        let consumer = BackendRequestConsumer.init(serviceConfiguration: BackendServiceConfiguration())
        let backendService = BackendService.init(consumer: consumer)
        return backendService
    }
    
    func produceImageCache() -> ImageCacheProtocol {
        return ImageCache.init()
    }
}
