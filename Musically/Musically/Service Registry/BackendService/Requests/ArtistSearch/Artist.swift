//
//  AlbumInfo.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

struct Artist: Codable {
    var name: String = ""
    var listeners: String = ""
    var mbid: String = ""
    var url: URL?
    var image: [AlbumImage]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.listeners = try container.decode(String.self, forKey: .listeners)
        self.mbid = try container.decode(String.self, forKey: .mbid)
        do {
            try self.url = container.decode(URL.self, forKey: .url)
        } catch {
            self.url = nil
        }
        self.image = try container.decode([AlbumImage].self, forKey: .image)
    }
}
