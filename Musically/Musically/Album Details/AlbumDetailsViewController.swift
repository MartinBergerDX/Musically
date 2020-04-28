//
//  AlbumDetailsViewController.swift
//  Musically
//
//  Created by Martin on 10/2/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import UIKit
import Foundation

class AlbumDetailsViewController: CommonViewController {
    @IBOutlet weak var viewModel: AlbumDetailsViewModel!
    @IBOutlet weak var scrollController: AlbumDetailsScrollController!
    
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
    
    @objc private func onSave(sender: UIBarButtonItem) {
        if viewModel.exists() {
            viewModel.remove()
        } else {
            viewModel.save()
        }
        updateSaveButton()
    }
    
    private func installSaveButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Save", style: .done, target: self, action: #selector(onSave(sender:)))
    }
    
    private func uninstallSaveButton() {
        self.navigationItem.rightBarButtonItem = nil
    }
    
    private func updateSaveButton() {
        let save = self.navigationItem.rightBarButtonItem
        save?.title = viewModel.exists() ? "Remove" : "Save"
    }
}

extension AlbumDetailsViewController: AlbumDetailsViewModelOutput {
    func updated(viewModel: AlbumDetailsViewModel) {
        if viewModel.anythingUseful() {
            installSaveButton()
            updateSaveButton()
            scrollController.setup(with: viewModel.albumDetails)
        } else {
            uninstallSaveButton()
            scrollController.noData()
        }
    }
}
