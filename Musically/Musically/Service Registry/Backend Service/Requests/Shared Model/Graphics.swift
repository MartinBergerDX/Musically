//
//  AlbumImage.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

struct Graphics: Codable {
    var url: URL? = .none
    var size: GraphicsSize? = .none
    
    enum CodingKeys: String, CodingKey {
        case url = "#text"
        case size = "size"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try? container.decode(URL.self, forKey: .url)
        size = try? container.decode(GraphicsSize.self, forKey: .size)
    }
}
