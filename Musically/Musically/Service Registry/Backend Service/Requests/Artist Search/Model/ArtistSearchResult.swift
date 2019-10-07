//
//  AlbumSearchResult.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

struct ArtistSearchResult {
    var artists: [Artist] = []
    var pagination = Pagination.init()
}

extension ArtistSearchResult: Decodable {
    enum CodingKeys: String, CodingKey {
        case results
        case artistmatches
        case artist
        
        case totalResults = "opensearch:totalResults"
        case itemsPerPage = "opensearch:itemsPerPage"
        
        case query = "opensearch:Query"
        case startPage = "startPage"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let results = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .results)
        let artistMatches = try results.nestedContainer(keyedBy: CodingKeys.self, forKey: .artistmatches)
        try self.artists = artistMatches.decode([Artist].self, forKey: .artist)
        
        let totalString: String = try results.decode(String.self, forKey: .totalResults)
        pagination.total = Int.init(totalString) ?? 0
        let limitString: String = try results.decode(String.self, forKey: .itemsPerPage)
        pagination.limit = Int.init(limitString) ?? 0
        
        let query = try results.nestedContainer(keyedBy: CodingKeys.self, forKey: .query)
        let startPageString: String = try query.decode(String.self, forKey: .startPage)
        pagination.page = Int.init(startPageString) ?? 0
    }
}
