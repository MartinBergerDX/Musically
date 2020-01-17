//
//  ArtistSearchTableViewDataSource.swift
//  Musically
//
//  Created by Martin on 1/17/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import UIKit

class ArtistSearchTableViewDataSource: NSObject, UITableViewDataSource {
    weak var viewModel: ArtistSearchViewModel!
    let router: AlbumsRouter!
    
    init (viewModel: ArtistSearchViewModel, router: AlbumsRouter) {
        self.viewModel = viewModel
        self.router = router
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let artist: Artist? = self.viewModel.artist(for: indexPath.row)
        let cell: ArtistTableViewCell = tableView.dequeueReusableCell(withIdentifier: ArtistTableViewCell.reuseId(), for:indexPath) as! ArtistTableViewCell
        cell.setup(with: artist)
        if let artist = artist {
            cell.viewTapBehaviour = ViewTapBehaviour.init(views: [cell.mainContainer], onTap: { [unowned self] (view: UIView) in
                self.router.showAlbums(for: artist)
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
