//
//  MusicallyTests.swift
//  MusicallyTests
//
//  Created by Martin on 10/3/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import XCTest
import Foundation
import CoreData
@testable import Musically

class PersistanceTests: XCTestCase {
    var stack: CoreDataStack!
    var model: AlbumDetails!
    
    override func setUp() {
        stack = CoreDataStack.init(modelName: "Musically")
        prepareModel()
    }

    override func tearDown() {
        let dao: AlbumDetailsDao = AlbumDetailsDao.init(moc: stack.managedObjectContext)
        dao.deleteAll()
        model = nil
    }

    private func prepareModel() {
        var ad = AlbumDetails.init()
        ad.albumName = "tn"
        ad.artistName = "ta"
        ad.playcount = "tp"
        ad.listeners = "tl"
        ad.mbid = "tm"
        ad.url = URL.init(string: "www.test.com")
        ad.published = "tpt"
        ad.summary = "tst"
        ad.content = "tct"
        
        var counter = 0
        GraphicsSize.allCases.forEach { (size) in
            var graphics = Graphics.init()
            counter += 1
            graphics.url = URL.init(string: "www.test.graphics." + String(counter))
            graphics.size = size
            ad.images.append(graphics)
        }
        
        for i in 0...5 {
            var tag = Tag.init()
            tag.name = "t" + String(i)
            tag.url = URL.init(string: "www.tag.com")
            ad.tags.append(tag)
        }
        
        for i in 0...12 {
            var track = Track.init()
            track.name = "ttn" + String(i)
            track.duration = "ttd" + String(i)
            ad.tracks.append(track)
        }
        model = ad
    }
    
    private func compare(ad: inout AlbumDetails, db: DBAlbumDetails) -> Bool {
        if db.artistName != ad.artistName {
            return false
        }
        if db.albumName != ad.albumName {
            return false
        }
        if db.playcount != ad.playcount {
            return false
        }
        if db.listeners != ad.listeners {
            return false
        }
        if db.mbid != ad.mbid {
            return false
        }
        if db.url != ad.url?.absoluteString {
            return false
        }
        if db.published != ad.published {
            return false
        }
        if db.content != ad.content {
            return false
        }
        
        if !compare(graphics: ad, db: db) {
            return false
        }
        
        if !compare(tags: ad, db: db) {
            return false
        }
        
        if !compare(tracks: ad, db: db) {
            return false
        }
        
        return true
    }
    
    private func compare(graphics domain: AlbumDetails, db: DBAlbumDetails) -> Bool {
        let graphicsDao = GraphicsDao.init(moc: stack.managedObjectContext)
        var converted: [Graphics] = []
        graphicsDao.convertCollectionCoreDataToDomain(db.images, domain: &converted)
        if Set(converted).symmetricDifference(Set(domain.images)).count > 0 {
            return false
        }
        return true
    }
    
    private func compare(tags domain: AlbumDetails, db: DBAlbumDetails) -> Bool {
        let tagDao = TagDao.init(moc: stack.managedObjectContext)
        var converted: [Tag] = []
        tagDao.convertCollectionCoreDataToDomain(db.tags, domain: &converted)
        if Set(converted).symmetricDifference(Set(domain.tags)).count > 0 {
            return false
        }
        return true
    }
    
    private func compare(tracks domain: AlbumDetails, db: DBAlbumDetails) -> Bool {
        let dao = TrackDao.init(moc: stack.managedObjectContext)
        var converted: [Track] = []
        dao.convertCollectionCoreDataToDomain(db.tracks, domain: &converted)
        if Set(converted).symmetricDifference(Set(domain.tracks)).count > 0 {
            return false
        }
        return true
    }
    
//    private func compare<DomainType: Comparable & Hashable, DaoType: GenericDao<NSManagedObject, DomainType>>(model objects: inout [DomainType], db: NSSet, dao: DaoType) -> Bool {
//        let dao = DaoType.init(moc: stack.managedObjectContext)
//        let converted: [DomainType] = []
//        dao.convertCollectionCoreDataToDomain(db, domain: &objects)
//        if Set(converted).symmetricDifference(Set(objects)).count > 0 {
//            return false
//        }
//        return true
//    }
    
    func testCompare() {
        let dao: AlbumDetailsDao = AlbumDetailsDao.init(moc: stack.managedObjectContext)
        let db = dao.insertNew()
        dao.domainToCoreData(model, dbObject: db)
        let equal = compare(ad: &model, db: db)
        XCTAssert(equal == true)
    }

}
