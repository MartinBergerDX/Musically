//
//  AlbumInfoRequest.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

// https://www.last.fm/api/show/artist.search

struct ArtistSearchRequest: BackendRequest, PagedBackendRequest {
    var pagination: Pagination = Pagination.init()
    var completion: ([Artist]) -> Void = { (infos: [Artist]) in }
    
    var endpoint: String = "artist.search"
    var arguments: String {
        get {
            return "artist=" + artist + pagingArguments()
        }
    }
    var method: String = HTTPMethod.get.description
    var artist: String = ""
    
    func onComplete(result: Result<Data,Error>) {
        switch result {
        case .success(let data):
            let decoder = JSONDecoder()
            var albumsFound = AlbumSearchResult.init()
            if let didFound = try? decoder.decode(AlbumSearchResult.self, from: data) {
                albumsFound = didFound
            }
            self.completion(albumsFound.albums)
            
        case .failure(let error):
            print("failure: " + error.localizedDescription)
            self.completion([])
        }
    }
}
