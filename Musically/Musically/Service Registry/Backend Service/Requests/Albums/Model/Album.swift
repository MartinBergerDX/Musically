//
//  Album.swift
//  Musically
//
//  Created by Martin on 10/2/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

struct Album: Codable {
    var name: String = ""
    var playcount: Int = 0
    var mbid: String = ""
    var url: URL? = .none
    var image: [Graphics]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.playcount = try container.decode(Int.self, forKey: .playcount)
        if let mbid = try? container.decode(String.self, forKey: .mbid) {
            self.mbid = mbid
        }
        do {
            try self.url = container.decode(URL.self, forKey: .url)
        } catch {
            // url constructor fails if string is empty eg. ""
        }
        self.image = try container.decode([Graphics].self, forKey: .image)
    }
}
