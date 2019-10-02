//
//  AlbumDetails.swift
//  Musically
//
//  Created by Martin on 10/2/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

struct AlbumDetails: Decodable {
    var name: String = ""
    var playcount: String?
    var listeners: String?
    var mbid: String = ""
    var url: URL? = .none
    var images: [Graphics] = []
    var tracks: [Track] = []
    
    enum CodingKeys: String, CodingKey {
        case name
        case playcount
        case listeners
        case mbid
        case url
        case images = "image"
        case tracks
        case track
        case album
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let album = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .album)
        
        name = try album.decode(String.self, forKey: .name)
        playcount = try? album.decode(String.self, forKey: .playcount)
        listeners = try? album.decode(String.self, forKey: .listeners)
        if let mbid = try? album.decode(String.self, forKey: .mbid) {
            self.mbid = mbid
        }
        url = try? album.decode(URL.self, forKey: .url)
        images = try album.decode([Graphics].self, forKey: .images)

        let tracks = try album.nestedContainer(keyedBy: CodingKeys.self, forKey: .tracks)
        self.tracks = try tracks.decode([Track].self, forKey: .track)
    }
}
