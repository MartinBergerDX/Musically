//
//  BackendRequestIterator.swift
//  Musically
//
//  Created by Martin on 4/15/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation

class BackendRequestIterator {
    private var iterator: IndexingIterator<[BackendRequestAttributesProtocol]>
    init(iterator: IndexingIterator<[BackendRequestAttributesProtocol]>) {
        self.iterator = iterator
    }
    func next() -> BackendRequestAttributesProtocol? {
        return iterator.next()
    }
    
    // Null-Object pattern
    static let null: BackendRequestIterator = {
        let it = IndexingIterator<[BackendRequestAttributesProtocol]>(_elements: [])
        return BackendRequestIterator.init(iterator: it)
    }()
}
