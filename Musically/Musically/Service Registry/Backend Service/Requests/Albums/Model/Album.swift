//
//  Album.swift
//  Musically
//
//  Created by Martin on 10/2/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

struct Album {
    var name: String = ""
    var playcount: Int = 0
    var mbid: String = ""
    var url: URL? = .none
    var images: [Graphics] = []
}

extension Album: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case playcount
        case mbid
        case url
        case images = "image"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        playcount = (try? container.decode(Int.self, forKey: .playcount)) ?? 0
        mbid = (try? container.decode(String.self, forKey: .mbid)) ?? ""
        url = try? container.decode(URL.self, forKey: .url)
        images = (try? container.decode([Graphics].self, forKey: .images)) ?? []
    }
}

extension Album: Comparable {
    static func ==(lhs: Album, rhs: Album) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func <(lhs: Album, rhs: Album) -> Bool {
        return lhs.name < rhs.name
    }
}
