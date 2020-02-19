//
//  AlbumInfoRequest.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

// https://www.last.fm/api/show/artist.search

class ArtistSearchRequest: BackendRequest, BackendRequestJsonMapping {
    
    var artist: String!
    var completion: ((Result<DataType, Error>) -> Void)?
    
    typealias DataType = ArtistSearchResult

    init(artist: String) {
        super.init()
        self.artist = artist
        endpoint = "artist.search"
        arguments = "artist=" + artist
    }
    
    override func onComplete(result: Result<Data,Error>) {
        switch result {
        case .success(let data):
            self.completion?(.success(guaranteeObject(from: data)))
        case .failure(let error):
            self.completion?(.failure(error))
        }
    }
}
