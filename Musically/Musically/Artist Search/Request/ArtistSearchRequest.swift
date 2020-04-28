//
//  AlbumInfoRequest.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

// https://www.last.fm/api/show/artist.search

class ArtistSearchRequest: BackendRequest<ArtistSearchResult> {
    private var artistQuery: String!

    init(artistQuery: String) {
        super.init()
        self.artistQuery = formatArtist(artistQuery: artistQuery)
        endpoint = "artist.search"
        arguments = []
        formatUrlArguments()
    }
    
    convenience init(artistQuery: String, page: Int) {
        self.init(artistQuery: artistQuery)
        self.pagination.page = page
    }
    
    private func formatArtist(artistQuery: String) -> String {
        return artistQuery.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? artistQuery
    }
    
    private func formatUrlArguments() {
        arguments.append(URLQueryItem.init(name: "artist", value: artistQuery))
    }
}
