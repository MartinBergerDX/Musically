//
//  ArtistSearchCellViewModel.swift
//  Musically
//
//  Created by Martin on 3/24/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation

protocol ArtistSearchCellViewModelProtocol {
    func artistName() -> String
    func artistListeners() -> String
    func artistIdentifier() -> String
    func hasArtistPhotoURL() -> Bool
    func artistPhotoURL() -> URL
    func isLoading() -> Bool
    func model() -> Artist
}

class ArtistSearchCellViewModel: ArtistSearchCellViewModelProtocol {
    private var photoURL: URL?
    private var loading: Bool
    private var artist: Artist
    
    init(artist: Artist) {
        self.photoURL = artist.mediumSizeImageUrl()
        self.artist = artist
        self.loading = false
    }
    
    func artistName() -> String {
        return artist.name
    }
    
    func artistListeners() -> String {
        return artist.listeners
    }
    
    func artistIdentifier() -> String {
        return artist.mbid
    }
    
    func hasArtistPhotoURL() -> Bool {
        return photoURL != nil
    }
    
    func artistPhotoURL() -> URL {
        return photoURL!
    }
    
    func isLoading() -> Bool {
        return loading
    }
    
    func model() -> Artist {
        return artist
    }
}

class ArtistSearchCellLoadingViewModel: ArtistSearchCellViewModelProtocol {
    func artistName() -> String {
        return "Loading"
    }
    
    func artistListeners() -> String {
        return "Listeners: ##"
    }
    
    func artistIdentifier() -> String {
        return "-"
    }
    
    func hasArtistPhotoURL() -> Bool {
        return false
    }
    
    func artistPhotoURL() -> URL {
        return URL(string: "")!
    }
    
    func isLoading() -> Bool {
        return true
    }
    
    func model() -> Artist {
        return Artist()
    }
}
