//
//  TagDao.swift
//  Musically
//
//  Created by Martin on 10/4/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import CoreData

class TagDao: GenericDao<DBTag, Tag> {
    override public init(moc: NSManagedObjectContext!) {
        super.init(moc: moc)
        defaultOrderBy = NSSortDescriptor(key: "name", ascending: true)
    }
    
    override public func domainToCoreData(_ domain: DomainType, dbObject: ManagedType) {
        if let name: String = domain.name {
            dbObject.name = name
        }
        if let url: URL = domain.url {
            dbObject.url = url.absoluteString
        }
    }
    
    override func coreDataToDomain(_ dbObject: ManagedType, domain: inout DomainType) {
        if let name = dbObject.name {
            domain.name = name
        }
        if let urlString = dbObject.url {
            domain.url = URL.init(string: urlString)
        }
    }
    
    override func produceDomainObject() -> DomainType? {
        return Tag.init()
    }
}
