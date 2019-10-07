//
//  StoredAlbumsViewModel.swift
//  Musically
//
//  Created by Martin on 10/5/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

protocol StoredAlbumsViewModelOutput: class {
    func updated(viewModel: StoredAlbumsViewModel)
}

class StoredAlbumsViewModel: NSObject {
    private var albums: [AlbumDetails] = []
    weak var output: StoredAlbumsViewModelOutput!
    
    func load() {
        albums.removeAll()
        let dao: AlbumDetailsDao = DaoFactory.albumDetails()
        let stored = dao.findAll()
        let set: NSSet = NSSet.init(array: stored)
        dao.convertCollectionCoreDataToDomain(set, domain: &albums)
        output.updated(viewModel: self)
    }
    
    func totalCount() -> Int {
        return albums.count
    }
    
    func object(for index: Int) -> AlbumDetails? {
        return albums[index]
    }
}
