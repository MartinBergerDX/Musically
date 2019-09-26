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
    var url: URL
    var image: [AlbumImage]
}
