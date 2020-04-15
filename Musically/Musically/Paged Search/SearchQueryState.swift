//
//  SearchQueryState.swift
//  Musically
//
//  Created by Martin on 4/7/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation

class SearchQueryState {
    static let DefaultQuery = ""
    var currentQuery: String! = DefaultQuery
    var newQuery: String! = DefaultQuery
    
    func queryUpdated() -> Bool {
        return currentQuery != newQuery
    }
    
    func update() {
        currentQuery = newQuery
    }
}
