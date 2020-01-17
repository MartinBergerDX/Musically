//
//  ArtistSearchTableViewPrefetching.swift
//  Musically
//
//  Created by Martin on 1/17/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import UIKit

class ArtistSearchTableViewPrefetching: NSObject, UITableViewDataSourcePrefetching {
    weak var viewModel: ArtistSearchViewModel!
    
    init (viewModel: ArtistSearchViewModel) {
        self.viewModel = viewModel
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let contains: Bool = indexPaths.contains { element in
            return self.viewModel.isLoading(for: element)
        }
        if contains {
            self.viewModel.search()
        }
    }
}
