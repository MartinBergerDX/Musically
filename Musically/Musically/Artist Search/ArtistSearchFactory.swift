//
//  ArtistSearchFactory.swift
//  Musically
//
//  Created by Martin on 1/17/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import UIKit

class ArtistSearchFactory {
    static func delegator(viewModel: ArtistSearchViewModel!, navigationController: UINavigationController!) -> ArtistSearchTableViewDelegator {
        let router = AlbumsRouter.init(navigationController: navigationController)
        let dataSource = ArtistSearchTableViewDataSource.init(viewModel: viewModel, router: router)
        let prefetching = ArtistSearchTableViewPrefetching.init(viewModel: viewModel)
        let delegator: ArtistSearchTableViewDelegator = ArtistSearchTableViewDelegator.init(dataSource: dataSource, prefetching: prefetching)
        return delegator
    }
    
    static func searchController(viewModel: ArtistSearchViewModel!) -> UISearchController {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = viewModel
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search artists"
        return searchController
    }
}
