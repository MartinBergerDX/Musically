//
//  GraphicsDao.swift
//  Musically
//
//  Created by Martin on 10/4/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import CoreData

class GraphicsDao: GenericDao<DBGraphics, Graphics> {
    override public init(moc: NSManagedObjectContext!) {
        super.init(moc: moc)
        defaultOrderBy = NSSortDescriptor(key: "size", ascending: true)
    }
    
    override public func domainToCoreData(_ domain: DomainType, dbObject: ManagedType) {
        if let size: String = domain.size?.rawValue {
            dbObject.size = size
        }
        if let url: URL = domain.url {
            dbObject.url = url.absoluteString
        }
    }
    
    override func coreDataToDomain(_ dbObject: ManagedType, domain: inout DomainType) {
        if let size: String = dbObject.size {
            domain.size = GraphicsSize.init(rawValue: size)
        }
        if let urlString: String = dbObject.url {
            domain.url = URL.init(string: urlString)
        }
    }
    
    override func produceDomainObject() -> DomainType? {
        return Graphics.init()
    }
}
