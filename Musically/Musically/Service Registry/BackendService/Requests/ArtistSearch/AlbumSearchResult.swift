//
//  AlbumSearchResult.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

struct AlbumSearchResult: Decodable {
    var albums: [Artist] = []
    
    enum CodingKeys: String, CodingKey {
        case results
        case artistmatches
        case artist
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let results = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .results)
        let artistMatches = try results.nestedContainer(keyedBy: CodingKeys.self, forKey: .artistmatches)
        try self.albums = artistMatches.decode([Artist].self, forKey: .artist)
    }
    
    init() {
        
    }
}
