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
        let contains: Bool = indexPaths.contains { element in
            return self.dataProvider.isLoading(for: element)
        }
        if contains {
            self.dataProvider.search()
        }
    }
}
