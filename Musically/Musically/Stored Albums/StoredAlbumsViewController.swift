//
//  ViewController.swift
//  Musically
//
//  Created by Martin on 9/25/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import UIKit

class StoredAlbumsViewController: UIViewController {
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewModel: StoredAlbumsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.output = self
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.load()
    }
    
    private func setupCollectionView() {
        let reuseId = String.init(describing: StoredAlbumsCollectionViewCell.self)
        collectionView.register(UINib(nibName: reuseId, bundle: Bundle.main), forCellWithReuseIdentifier: reuseId)
    }
    
    private func showAlbumDetails(for album: Album) {
        let vc = AlbumDetailsViewController.storyboardViewController(from: "Main")
        vc.album = album
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onSearch() {
        let asvc = ArtistSearchViewController.storyboardViewController(from: "Main")
        self.navigationController?.pushViewController(asvc, animated: true)
    }
}

extension StoredAlbumsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_: UICollectionView, numberOfItemsInSection: Int) -> Int {
        return viewModel.totalCount()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseId = String.init(describing: StoredAlbumsCollectionViewCell.self)
        let cell: StoredAlbumsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! StoredAlbumsCollectionViewCell
        if let albumDetails: AlbumDetails = viewModel.object(for: indexPath.row) {
            cell.setup(with: albumDetails)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(arc4random() % 5)) {
            cell.startAnimations()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let albumDetails = viewModel.object(for: indexPath.row) else {
            return
        }
        var album = Album.init()
        album.mbid = albumDetails.mbid
        showAlbumDetails(for: album)
    }
}

extension StoredAlbumsViewController: UICollectionViewDelegateFlowLayout {
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

extension StoredAlbumsViewController: StoredAlbumsViewModelOutput {
    func updated(viewModel: StoredAlbumsViewModel) {
        collectionView.reloadData()
    }
}
