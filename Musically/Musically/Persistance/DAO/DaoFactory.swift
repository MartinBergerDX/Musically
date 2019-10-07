//
//  DaoFactory.swift
//  Musically
//
//  Created by Martin on 10/3/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation
import CoreData

protocol DaoFactoryProtocol {
    static func albumDetails() -> AlbumDetailsDao!
}

class DaoFactory: DaoFactoryProtocol {
    
    private static func moc() -> NSManagedObjectContext {
        let moc: NSManagedObjectContext!
        if let _ : String = ProcessInfo.processInfo.environment["TESTING"] {
            moc = CoreDataStack.init(modelName: CoreDataStack.defaultModelName).managedObjectContext
        } else {
            moc = ServiceRegistry.shared.database.managedObjectContext
        }
        return moc
    }
    
    static func albumDetails() -> AlbumDetailsDao! {
        return AlbumDetailsDao.init(moc: DaoFactory.moc())
    }
}
