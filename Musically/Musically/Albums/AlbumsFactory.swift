//
//  AlbumsFactory.swift
//  Musically
//
//  Created by Martin on 1/17/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import UIKit

class AlbumsViewControllerFactory {
    static func delegator(viewModel: AlbumsViewModel, navigationController: UINavigationController!) -> AlbumsTableViewDelegator {
        let router = AlbumDetailsRouter.init(navigationController: navigationController)
        let dataSource = AlbumsTableViewDataSource.init(viewModel: viewModel, router: router)
        let prefetching = AlbumsTableViewPrefetching.init(viewModel: viewModel)
        let delegator = AlbumsTableViewDelegator.init(dataSource: dataSource, prefetching: prefetching)
        return delegator
    }
}
