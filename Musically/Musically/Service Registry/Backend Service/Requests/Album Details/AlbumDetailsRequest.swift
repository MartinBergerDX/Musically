//
//  AlbumDetailsRequest.swift
//  Musically
//
//  Created by Martin on 10/2/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

class AlbumDetailsRequest: BackendRequest<AlbumDetails> {
    var completion: ((Result<AlbumDetails, Error>) -> Void)?
    var mbid: String = ""
    var albumName: String = ""
    
    init (albumName: String, mbid: String) {
        super.init()
        self.albumName = albumName
        self.mbid = mbid
        endpoint = "album.getinfo"
        arguments = []
        formatUrlArguments()
    }
    
    private func formatUrlArguments() {
        if !mbid.isEmpty {
            arguments.append(URLQueryItem.init(name: "mbid", value: mbid))
        }
        if !albumName.isEmpty {
            arguments.append(URLQueryItem.init(name: "album", value: albumName))
        }
    }
}
