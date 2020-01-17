//
//  StoredAlbumsCollectionViewDataSource.swift
//  Musically
//
//  Created by Martin on 1/15/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import UIKit

class StoredAlbumsCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    let viewModel: StoredAlbumsViewModel!
    
    init(viewModel: StoredAlbumsViewModel!) {
        self.viewModel = viewModel
    }
    
    func collectionView(_: UICollectionView, numberOfItemsInSection: Int) -> Int {
        return viewModel.totalCount()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: StoredAlbumsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: StoredAlbumsCollectionViewCell.reuseId(), for: indexPath) as! StoredAlbumsCollectionViewCell
        if let albumDetails: AlbumDetails = viewModel.object(for: indexPath.row) {
            cell.setup(with: albumDetails)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(arc4random() % 5)) {
            cell.startAnimations()
        }
        return cell
    }
    
}
