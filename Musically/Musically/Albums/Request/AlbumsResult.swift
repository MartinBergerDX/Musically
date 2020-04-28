//
//  AlbumsResult.swift
//  Musically
//
//  Created by Martin on 10/2/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

struct AlbumsResult {
    var albums: [Album] = []
    var pagination = RequestPaging.init()
}

extension AlbumsResult: Decodable {
    enum CodingKeys: String, CodingKey {
        case topalbums
        case album
        
        case attr = "@attr"
        case totalResults = "total"
        case itemsPerPage = "perPage"
        case page
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let topalbums = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .topalbums)
        try self.albums = topalbums.decode([Album].self, forKey: .album)
        
        let attributes = try topalbums.nestedContainer(keyedBy: CodingKeys.self, forKey: .attr)
        let totalString: String = try attributes.decode(String.self, forKey: .totalResults)
        pagination.total = Int.init(totalString) ?? 0
        let limitString: String = try attributes.decode(String.self, forKey: .itemsPerPage)
        pagination.limit = Int.init(limitString) ?? 0
        let startPageString: String = try attributes.decode(String.self, forKey: .page)
        pagination.page = Int.init(startPageString) ?? 0
    }
}

extension AlbumsResult: Initable {
    
}
