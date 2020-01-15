//
//  StoredAlbumsCollectionViewPresenter.swift
//  Musically
//
//  Created by Martin on 1/15/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import UIKit

class StoredAlbumsCollectionViewConfigurator: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let delegate: StoredAlbumsCollectionViewDelegate
    private let dataSource: StoredAlbumsCollectionViewDataSource
    private let layout: StoredAlbumsCollectionViewLayout
    private var collectionView: UICollectionView!
    
    init (delegate: StoredAlbumsCollectionViewDelegate, dataSource: StoredAlbumsCollectionViewDataSource, layout: StoredAlbumsCollectionViewLayout) {
        self.delegate = delegate
        self.dataSource = dataSource
        self.layout = layout
    }
    
    func bind(collectionView: UICollectionView!) {
        self.collectionView = collectionView
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    //MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    //MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection: Int) -> Int {
        return dataSource.collectionView(collectionView, numberOfItemsInSection: numberOfItemsInSection)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.numberOfSections(in: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return layout.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return layout.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return layout.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section)
    }
}
