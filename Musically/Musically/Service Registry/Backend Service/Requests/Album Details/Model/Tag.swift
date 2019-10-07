//
//  Tag.swift
//  Musically
//
//  Created by Martin on 10/3/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

struct Tag: Codable, Hashable {
    var name: String?
    var url: URL?
}

extension Tag: Comparable {
    static func ==(lhs: Tag, rhs: Tag) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func <(lhs: Tag, rhs: Tag) -> Bool {
        return (lhs.name ?? "") < (rhs.name ?? "")
    }
}
