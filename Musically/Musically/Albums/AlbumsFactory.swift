//
//  AlbumsFactory.swift
//  Musically
//
//  Created by Martin on 1/17/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import UIKit

class AlbumsViewControllerFactory {
    static func delegator(dataProvider: AlbumsDataProvider, navigationController: UINavigationController!) -> AlbumsTableViewDelegator {
        let router = AlbumDetailsRouter.init(navigationController: navigationController)
        let dataSource = AlbumsTableViewDataSource.init(dataProvider: dataProvider, router: router)
        let prefetching = AlbumsTableViewPrefetching.init(dataProvider: dataProvider)
        let delegator = AlbumsTableViewDelegator.init(dataSource: dataSource, prefetching: prefetching)
        return delegator
    }
}
