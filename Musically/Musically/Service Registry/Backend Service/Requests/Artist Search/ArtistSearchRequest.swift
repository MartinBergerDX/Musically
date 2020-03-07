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
    typealias DataType = ArtistSearchResult
    
    var artistQuery: String!
    var completion: ((Result<DataType, Error>) -> Void)?

    init(artistQuery: String) {
        super.init()
        self.artistQuery = artistQuery
        endpoint = "artist.search"
        formatArguments()
    }
    
    convenience init(artistQuery: String, page: Int) {
        let formattedArtist = artistQuery.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? artistQuery
        self.init(artistQuery: formattedArtist)
        self.pagination.page = page
    }
    
    override func onComplete(result: Result<Data,Error>) {
        switch result {
        case .success(let data):
            self.completion?(.success(mapJsonButReturnNullObjectOnMapException(from: data)))
        case .failure(let error):
            self.completion?(.failure(error))
        }
    }
    
    private func formatArguments() {
        arguments = "artist=" + artistQuery
    }
}
