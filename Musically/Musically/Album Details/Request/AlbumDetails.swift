//
//  AlbumDetails.swift
//  Musically
//
//  Created by Martin on 10/2/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

struct AlbumDetails {
    var albumName: String = ""
    var artistName: String = ""
    var playcount: String = ""
    var listeners: String = ""
    var mbid: String = ""
    var url: URL? = .none
    var images: [Graphics] = []
    var tracks: [Track] = []
    var tags: [Tag] = []
    var published: String = ""
    var summary: String = ""
    var content: String = ""
}

extension AlbumDetails: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case artist
        case playcount
        case listeners
        case mbid
        case url
        case images = "image"
        case tracks
        case track
        case album
        case tags
        case tag
        case wiki
        case published
        case summary
        case content
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let album = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .album) else {
            return
        }
        
        albumName = (try? album.decode(String.self, forKey: .name)) ?? ""
        artistName = (try? album.decode(String.self, forKey: .artist)) ?? ""
        playcount = (try? album.decode(String.self, forKey: .playcount)) ?? ""
        listeners = (try? album.decode(String.self, forKey: .listeners)) ?? ""
        mbid = (try? album.decode(String.self, forKey: .mbid)) ?? ""
        url = try? album.decode(URL.self, forKey: .url)
        images = (try? album.decode([Graphics].self, forKey: .images)) ?? []
        
        if let tracks = try? album.nestedContainer(keyedBy: CodingKeys.self, forKey: .tracks) {
            self.tracks = (try? tracks.decode([Track].self, forKey: .track)) ?? []
        }
        
        if let tags = try? album.nestedContainer(keyedBy: CodingKeys.self, forKey: .tags) {
            self.tags = (try? tags.decode([Tag].self, forKey: .tag)) ?? []
        }
        
        if let wiki = try? album.nestedContainer(keyedBy: CodingKeys.self, forKey: .wiki) {
            published = (try? wiki.decode(String.self, forKey: .published)) ?? ""
            summary = (try? wiki.decode(String.self, forKey: .summary)) ?? ""
            content = (try? wiki.decode(String.self, forKey: .content)) ?? ""
        }
    }
}

extension AlbumDetails: Comparable {
    static func ==(lhs: AlbumDetails, rhs: AlbumDetails) -> Bool {
        return lhs.albumName == rhs.albumName
    }
    
    static func <(lhs: AlbumDetails, rhs: AlbumDetails) -> Bool {
        return lhs.albumName < rhs.albumName
    }
}

extension AlbumDetails: Initable {
    
}
