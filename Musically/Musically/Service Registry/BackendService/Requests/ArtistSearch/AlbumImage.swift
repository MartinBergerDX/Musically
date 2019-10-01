//
//  AlbumImage.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

struct AlbumImage: Codable {
    var url: URL?
    var size: AlbumImageSize
    
    enum CodingKeys: String, CodingKey {
        case url = "#text"
        case size = "size"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            try self.url = container.decode(URL.self, forKey: .url)
        } catch {
            self.url = nil
        }
        try self.size = container.decode(AlbumImageSize.self, forKey: .size)
    }
}
