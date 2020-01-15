//
//  StoredAlbumsCollectionViewLayout.swift
//  Musically
//
//  Created by Martin on 1/15/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import UIKit

class StoredAlbumsCollectionViewLayout: NSObject, UICollectionViewDelegateFlowLayout {
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    private let itemsPerRow: CGFloat = 2
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var availableWidth = collectionView.frame.width
        availableWidth -= (itemsPerRow + 1) * sectionInsets.left
        let length = floor(availableWidth / itemsPerRow)
        let size = CGSize.init(width: length, height: length)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
