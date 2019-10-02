//
//  AlbumDetailsViewController.swift
//  Musically
//
//  Created by Martin on 10/2/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import UIKit

class AlbumDetailsViewController: UIViewController {
    @IBOutlet weak var viewModel: AlbumDetailsViewModel!
    @IBOutlet weak var mainStack: UIStackView!
    var album: Album!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }
    
    private func setupViewModel() {
        viewModel.backendService = ServiceRegistry.shared.backendService
        viewModel.output = self
        viewModel.album = album
        viewModel.search()
    }
}

extension AlbumDetailsViewController: AlbumDetailsViewModelOutput {
    func updated(viewModel: AlbumDetailsViewModel) {
        print(viewModel.albumDetails)
    }
}
