//
//  Pagination.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

struct Pagination {
    static let defaultLimit = 30
    static let defaultPage = 1
    var limit: Int = Pagination.defaultLimit
    var page: Int = Pagination.defaultPage
    var total: Int = 0
    
    mutating func nextPage() {
        self.page += 1
    }
    
    mutating func reset() {
        self.page = Pagination.defaultPage
    }
}
