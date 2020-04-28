//
//  ArtistSearchFactory.swift
//  Musically
//
//  Created by Martin on 1/17/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import UIKit

protocol ArtistSearchRequestFactoryProtocol {
    func delegator(viewModel: ArtistSearchDataProvider!, navigationController: UINavigationController!) -> ArtistSearchTableViewDelegator
    func searchController(updater: UISearchResultsUpdating) -> UISearchController
}

class ArtistSearchFactory: ArtistSearchRequestFactoryProtocol {
    func delegator(viewModel: ArtistSearchDataProvider!, navigationController: UINavigationController!) -> ArtistSearchTableViewDelegator {
        let router = AlbumsRouter.init(navigationController: navigationController)
        let dataSource = ArtistSearchTableViewDataSource.init(viewModel: viewModel, router: router)
        let prefetching = ArtistSearchTableViewPrefetching.init(dataProvider: viewModel)
        let delegator: ArtistSearchTableViewDelegator = ArtistSearchTableViewDelegator.init(dataSource: dataSource, prefetching: prefetching)
        return delegator
    }
    
    func searchController(updater: UISearchResultsUpdating) -> UISearchController {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = updater
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search artists"
        return searchController
    }
}
