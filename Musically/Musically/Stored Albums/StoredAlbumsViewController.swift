//
//  ViewController.swift
//  Musically
//
//  Created by Martin on 9/25/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import UIKit

class StoredAlbumsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewModel: StoredAlbumsViewModel!
    private var collectionViewDelegator: StoredAlbumsCollectionViewDelegator!
    
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
        self.collectionViewDelegator = StoredAlbumsFactory.produce(viewModel: viewModel, navigationController: self.navigationController)
        self.collectionViewDelegator.bind(collectionView: collectionView)
    }
    
    @IBAction func onSearch() {
        let asvc = ArtistSearchViewController.storyboardViewController(from: "Main")
        self.navigationController?.pushViewController(asvc, animated: true)
    }
}

extension StoredAlbumsViewController: StoredAlbumsViewModelOutput {
    func updated(viewModel: StoredAlbumsViewModel) {
        collectionView.reloadData()
    }
}
