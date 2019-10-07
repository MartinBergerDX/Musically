//
//  AlbumDetailsDAO.swift
//  Musically
//
//  Created by Martin on 10/3/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import CoreData

class AlbumDetailsDao: GenericDao<DBAlbumDetails, AlbumDetails> {
    override public init(moc: NSManagedObjectContext!) {
        super.init(moc: moc)
        attributeID = "mbid"
        defaultOrderBy = NSSortDescriptor(key: "albumName", ascending: true)
    }
    
    override public func domainToCoreData(_ domain: DomainType, dbObject: ManagedType) {
        dbObject.artistName = domain.artistName
        dbObject.content = domain.content
        dbObject.listeners = domain.listeners
        dbObject.mbid = domain.mbid
        dbObject.albumName = domain.albumName
        dbObject.playcount = domain.playcount
        dbObject.published = domain.published
        if let url: URL = domain.url {
            dbObject.url = url.absoluteString
        }
        
        dbObject.images = GraphicsDao.init(moc: self.moc).convertCollectionDomainToCoreData(domain.images)

        dbObject.tags = TagDao.init(moc: self.moc).convertCollectionDomainToCoreData(domain.tags)

        dbObject.tracks = TrackDao.init(moc: self.moc).convertCollectionDomainToCoreData(domain.tracks)
    }
    
    override func coreDataToDomain(_ dbObject: ManagedType, domain: inout DomainType) {
        if let artistName = dbObject.artistName {
            domain.artistName = artistName
        }
        if let content = dbObject.content {
            domain.content = content
        }
        if let listeners = dbObject.listeners {
            domain.listeners = listeners
        }
        if let mbid = dbObject.mbid {
            domain.mbid = mbid
        }
        if let albumName = dbObject.albumName {
            domain.albumName = albumName
        }
        if let playcount = dbObject.playcount {
            domain.playcount = playcount
        }
        if let published = dbObject.published {
            domain.published = published
        }
        if let urlString = dbObject.url {
            domain.url = URL.init(string: urlString)
        }

        GraphicsDao.init(moc: self.moc).convertCollectionCoreDataToDomain(dbObject.images, domain: &domain.images)
        
        TagDao.init(moc: self.moc).convertCollectionCoreDataToDomain(dbObject.tags, domain: &domain.tags)
        
        TrackDao.init(moc: self.moc).convertCollectionCoreDataToDomain(dbObject.tracks, domain: &domain.tracks)
    }
    
    override func produceDomainObject() -> DomainType? {
        return AlbumDetails.init()
    }
}
