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
    private weak var viewModel: AlbumsViewModel!
    
    init (viewModel: AlbumsViewModel, router: AlbumDetailsRouter) {
        self.viewModel = viewModel
        self.router = router
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let album: Album? = self.viewModel.album(for: indexPath.row)
        let cell: AlbumTableViewCell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.reuseId(), for:indexPath) as! AlbumTableViewCell
        cell.setup(with: album)
        if let album = album {
            cell.viewTapBehaviour = ViewTapBehaviour.init(views: [cell.mainContainer], onTap: { [unowned self] (view: UIView) in
                self.router.showAlbumDetails(for: album)
            })
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.totalCount()
    }
}
