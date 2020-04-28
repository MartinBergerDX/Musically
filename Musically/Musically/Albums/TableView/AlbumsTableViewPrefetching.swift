//
//  AlbumsTableViewPrefetching.swift
//  Musically
//
//  Created by Martin on 1/17/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import UIKit

class AlbumsTableViewPrefetching: NSObject, UITableViewDataSourcePrefetching {
    private weak var dataProvider: AlbumsDataProvider!
    
    init (dataProvider: AlbumsDataProvider!) {
        self.dataProvider = dataProvider
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let contains: Bool = indexPaths.contains { self.dataProvider.isNearEnd(for: $0) }
        if !contains {
            self.dataProvider.search()
        }
    }
}
