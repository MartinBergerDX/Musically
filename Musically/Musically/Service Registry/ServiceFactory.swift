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
    func produceImageCache() -> NSCache<NSString, UIImage>
}

// Abstract Factory pattern
class ProductionServiceFactory: ServiceFactoryProtocol {
    func produceDatabase() -> DatabaseProtocol {
        return CoreDataStack.init(modelName: CoreDataStack.defaultModelName)
    }
    
    func produceBackendService() -> BackendServiceProtocol {
        let backendRequestExecution = BackendRequestExecution.init(serviceConfiguration: BackendServiceConfiguration())
        let backendService = BackendService.init(backendRequestExecution: backendRequestExecution)
        return backendService
    }
    
    func produceImageCache() -> NSCache<NSString, UIImage> {
        return NSCache<NSString, UIImage>.init()
    }
}
