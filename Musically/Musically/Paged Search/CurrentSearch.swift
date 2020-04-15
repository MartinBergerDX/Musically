//
//  CurrentSearch.swift
//  Musically
//
//  Created by Martin on 4/15/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation

class CurrentSearch {
    func isInProgress(iterator: BackendRequestIterator, page: Int) -> Bool {
        while let request = iterator.next() {
            if request.pagination.page == page {
                return true
            }
        }
        return false
    }
}
