//
//  AlbumInfo.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

struct Artist: Hashable {
    var name: String = ""
    var listeners: String = ""
    var mbid: String = ""
    var url: URL? = .none
    var image: [Graphics] = []
    
    func mediumSizeImageUrl() -> URL? {
        let medium = image.filter { (graphics) -> Bool in
            return graphics.size == GraphicsSize.medium
        }
        if let imageUrl: URL = medium.first?.url {
            return imageUrl
        }
        return .none
    }
}

extension Artist: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        listeners = (try? container.decode(String.self, forKey: .listeners)) ?? ""
        mbid = try container.decode(String.self, forKey: .mbid)
        url = try? container.decode(URL.self, forKey: .url)
        image = (try? container.decode([Graphics].self, forKey: .image)) ?? []
    }
}
