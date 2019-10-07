//
//  AlbumDetailsViewController.swift
//  Musically
//
//  Created by Martin on 10/2/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import UIKit
import Foundation

class AlbumDetailsViewController: UIViewController {
    @IBOutlet weak var viewModel: AlbumDetailsViewModel!
    @IBOutlet weak var scrollController: AlbumDetailsScrollController!
    
    var album: Album!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Save", style: .done, target: self, action: #selector(onSave(sender:)))
        updateSaveButton()
    }
    
    @objc private func onSave(sender: UIBarButtonItem) {
        if viewModel.exists() {
            viewModel.remove()
        } else {
            viewModel.save()
        }
        updateSaveButton()
    }
    
    private func setupViewModel() {
        viewModel.backendService = ServiceRegistry.shared.backendService
        viewModel.output = self
        viewModel.album = album
        viewModel.search()
    }
    
    private func updateSaveButton() {
        let save = self.navigationItem.rightBarButtonItem
        save?.title = viewModel.exists() ? "Remove" : "Save"
    }
}

extension AlbumDetailsViewController: AlbumDetailsViewModelOutput {
    func updated(viewModel: AlbumDetailsViewModel) {
        scrollController.setup(with: viewModel.albumDetails)
    }
}
