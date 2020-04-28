//
//  AlbumRequest.swift
//  Musically
//
//  Created by Martin on 10/2/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

class AlbumRequest: BackendRequest<AlbumsResult> {
    private var mbid: String!
    private var artistName: String!

    init (artistName: String, mbid: String, page: Int) {
        super.init()
        self.artistName = artistName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        self.mbid = mbid.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        pagination.page = page
        endpoint = "artist.gettopalbums"
        arguments = []
        formatUrlArguments()
    }
    
    private func formatUrlArguments() {
        if !mbid.isEmpty {
            arguments.append(URLQueryItem.init(name: "mbid", value: mbid))
        }
        if !artistName.isEmpty {
            arguments.append(URLQueryItem.init(name: "artist", value: artistName))
        }
    }
}
