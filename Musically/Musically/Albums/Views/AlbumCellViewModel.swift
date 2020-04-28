//
//  AlbumCellViewModel.swift
//  Musically
//
//  Created by Martin on 4/26/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation

protocol AlbumCellViewModelProtocol {
    func name() -> String
    func playcount() -> String
    func albumPhotoURL() -> URL
    func hasAlbumPhotoURL() -> Bool
    func albumIdentifier() -> String
    func model() -> Album
}

class AlbumCellViewModel: AlbumCellViewModelProtocol {
    private var album: Album!
    private var photoURL: URL?
    
    init(album: Album) {
        self.album = album
        photoURL = album.mediumSizeImageUrl()
    }
    
    func name() -> String {
        return album.name
    }
    
    func playcount() -> String {
        return "Played: " + String(album.playcount) + " times."
    }
    
    func albumPhotoURL() -> URL {
        return photoURL!
    }
    
    func hasAlbumPhotoURL() -> Bool {
        return photoURL != nil
    }
    
    func albumIdentifier() -> String {
        return album.mbid
    }

    func model() -> Album {
        return album
    }
}
