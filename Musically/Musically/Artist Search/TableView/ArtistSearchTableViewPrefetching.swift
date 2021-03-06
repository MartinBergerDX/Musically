//
//  ArtistSearchTableViewPrefetching.swift
//  Musically
//
//  Created by Martin on 1/17/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import UIKit

class ArtistSearchTableViewPrefetching: NSObject, UITableViewDataSourcePrefetching {
    weak var dataProvider: ArtistSearchDataProvider!
    
    init (dataProvider: ArtistSearchDataProvider) {
        self.dataProvider = dataProvider
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let contains: Bool = indexPaths.contains { self.dataProvider.isNearEnd(for: $0) }
        if !contains {
            self.dataProvider.search()
        }
    }
}
