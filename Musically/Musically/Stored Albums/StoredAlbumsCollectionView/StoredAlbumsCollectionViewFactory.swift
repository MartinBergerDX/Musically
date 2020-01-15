//
//  StoredAlbumsCollectionViewFactory.swift
//  Musically
//
//  Created by Martin on 1/15/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import UIKit

// produced object will rarely be instantiated, maybe using the factory is not justified, but we will use it anyway

class StoredAlbumsFactory {
    static func produce(viewModel: StoredAlbumsViewModel!, navigationController: UINavigationController!) -> StoredAlbumsCollectionViewConfigurator {
        let router = AlbumDetailsRouter.init(navigationController: navigationController)
        let dataSource = StoredAlbumsCollectionViewDataSource.init(viewModel: viewModel)
        let delegate = StoredAlbumsCollectionViewDelegate.init(viewModel: viewModel, router: router)
        let layout = StoredAlbumsCollectionViewLayout.init()
        return StoredAlbumsCollectionViewConfigurator.init(delegate: delegate, dataSource: dataSource, layout: layout)
    }
}
