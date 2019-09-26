//
//  AlbumImage.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

struct AlbumImage: Codable {
    var url: URL
    var size: AlbumImageSize
    
    enum CodingKeys: String, CodingKey {
        case url = "#text"
        case size = "size"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try self.url = container.decode(URL.self, forKey: .url)
        try self.size = container.decode(AlbumImageSize.self, forKey: .size)
    }
}
