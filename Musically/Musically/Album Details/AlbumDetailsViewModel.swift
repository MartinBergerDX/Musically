//
//  AlbumDetailsViewModel.swift
//  Musically
//
//  Created by Martin on 10/2/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

protocol AlbumDetailsViewModelOutput: class {
    func updated(viewModel: AlbumDetailsViewModel)
}

class AlbumDetailsViewModel: NSObject {
    weak var output: AlbumDetailsViewModelOutput!
    var backendService: BackendServiceProtocol!
    var album: Album!
    private (set) var albumDetails: AlbumDetails!
    
    override init() {
        super.init()
    }
    
    func search() {
        var request = AlbumDetailsRequest.init()
        request.album = album.name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        request.mbid = album.mbid.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        request.completion = { [unowned self] (result) in
            self.searchFinished(with: result)
            self.output.updated(viewModel: self)
        }
        self.backendService.execute(request: request)
    }
    
    private func searchFinished(with result: Result<AlbumDetails, Error>) {
        switch result {
        case .success(let received):
            albumDetails = received
            break
        case .failure(let error):
            print(error)
            break
        }
    }
    
    func exists() -> Bool {
        let dao: AlbumDetailsDao! = DaoFactory.albumDetails()
        if let _ = dao.findByID(album.mbid as AnyObject) {
            return true
        }
        return false
    }
    
    func save() {
        let dao: AlbumDetailsDao = DaoFactory.albumDetails()
        let db = dao.insertNew()
        dao.domainToCoreData(albumDetails, dbObject: db)
        dao.save()
    }
    
    func remove() {
        let dao: AlbumDetailsDao = DaoFactory.albumDetails()
        let mbid = albumDetails.mbid
        if let found = dao.findByID(mbid as AnyObject) {
            dao.delete(found, save: true)
        }
    }
    
    func anythingUseful() -> Bool {
        return !albumDetails.albumName.isEmpty || !albumDetails.mbid.isEmpty || !albumDetails.content.isEmpty
    }
}
