//
//  TrackDao.swift
//  Musically
//
//  Created by Martin on 10/4/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import CoreData

class TrackDao: GenericDao<DBTrack, Track> {
    
    override public init(moc: NSManagedObjectContext!) {
        super.init(moc: moc)
        defaultOrderBy = NSSortDescriptor(key: "name", ascending: true)
    }
    
    override public func domainToCoreData(_ domain: DomainType, dbObject: ManagedType) {
        if !domain.name.isEmpty {
            dbObject.name = domain.name
        }
        if !domain.duration.isEmpty {
            dbObject.duration = domain.duration
        }
        if let url: URL = domain.url {
            dbObject.url = url.absoluteString
        }
    }
    
    override func coreDataToDomain(_ dbObject: ManagedType, domain: inout DomainType) {
        if let name = dbObject.name {
            domain.name = name
        }
        if let duration = dbObject.duration {
            domain.duration = duration
        }
        if let urlString: String = dbObject.url {
            domain.url = URL.init(string: urlString)
        }
    }
    
    override func produceDomainObject() -> DomainType? {
        return Track.init()
    }
}
