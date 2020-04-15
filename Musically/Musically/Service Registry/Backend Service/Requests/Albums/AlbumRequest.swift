//
//  AlbumRequest.swift
//  Musically
//
//  Created by Martin on 10/2/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

class AlbumRequest: BackendRequest<AlbumsResult> {
    var completion: ((Result<AlbumsResult, Error>) -> Void)?

    var mbid: String = ""
    var artistName: String = ""

    init (artistName: String, mbid: String) {
        super.init()
        self.artistName = artistName
        self.mbid = mbid
        endpoint = "artist.search"
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
