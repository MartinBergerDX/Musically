//
//  Track.swift
//  Musically
//
//  Created by Martin on 10/2/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

struct Track: Decodable {
    var name: String
    var url: URL?
    var duration: String
    var rank: String
    var streamableText: String
    var streamableFullTrack: String
    var artist: Artist
    
    enum CodingKeys: String, CodingKey {
        case name
        case duration
        case attr = "@attr"
        case rank
        case streamable
        case text = "#text"
        case fulltrack
        case artist
        case mbid
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        duration = try container.decode(String.self, forKey: .duration)
        let attributes = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .attr)
        rank = try attributes.decode(String.self, forKey: .rank)
        
        self.url = try? container.decode(URL.self, forKey: .url)
        
        let streamable = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .streamable)
        streamableText = try streamable.decode(String.self, forKey: .text)
        streamableFullTrack = try streamable.decode(String.self, forKey: .fulltrack)
        
        artist = try container.decode(Artist.self, forKey: .artist)
    }
}
