//
//  ArtistSearchTableViewDataSource.swift
//  Musically
//
//  Created by Martin on 1/17/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import UIKit

class ArtistSearchTableViewDataSource: NSObject, UITableViewDataSource {
    weak var dataProvider: ArtistSearchDataProvider!
    let router: AlbumsRouter!
    
    init (viewModel: ArtistSearchDataProvider, router: AlbumsRouter) {
        self.dataProvider = viewModel
        self.router = router
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = self.dataProvider.viewModel(for: indexPath.row)
        let cell: ArtistTableViewCell = tableView.dequeueReusableCell(withIdentifier: ArtistTableViewCell.reuseId(), for:indexPath) as! ArtistTableViewCell
        cell.setup(with: viewModel)
        cell.set { [unowned self] in
            self.router.showAlbums(for: viewModel.model())
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
