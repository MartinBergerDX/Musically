//
//  AlbumsTableViewDataSource.swift
//  Musically
//
//  Created by Martin on 1/17/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import UIKit

class AlbumsTableViewDataSource: NSObject, UITableViewDataSource {
    private let router: AlbumDetailsRouter!
    private var dataProvider: AlbumsDataProvider!
    
    init (dataProvider: AlbumsDataProvider, router: AlbumDetailsRouter) {
        self.dataProvider = dataProvider
        self.router = router
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = self.dataProvider.viewModel(for: indexPath.row)
        let cell: AlbumTableViewCell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.reuseId(), for:indexPath) as! AlbumTableViewCell
        cell.setup(with: viewModel)
        cell.set { [unowned self] in
            self.router.showAlbumDetails(for: viewModel.model())
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataProvider.totalCount()
    }
}
