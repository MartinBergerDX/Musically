//
//  StoredAlbumsCollectionViewDelegate.swift
//  Musically
//
//  Created by Martin on 1/15/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import UIKit

class StoredAlbumsCollectionViewDelegate : NSObject, UICollectionViewDelegate {
    private let viewModel: StoredAlbumsViewModel!
    private let router: AlbumDetailsRouter!
    
    init(viewModel: StoredAlbumsViewModel!, router: AlbumDetailsRouter!) {
        self.viewModel = viewModel
        self.router = router
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let albumDetails = viewModel.object(for: indexPath.row) else {
            return
        }
        var album = Album.init()
        album.mbid = albumDetails.mbid
        router.showAlbumDetails(for: album)
    }
}
