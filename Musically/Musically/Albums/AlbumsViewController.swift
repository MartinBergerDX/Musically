//
//  AlbumsViewController.swift
//  Musically
//
//  Created by Martin on 10/2/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import UIKit

class AlbumsViewController: UIViewController {
    @IBOutlet weak var viewModel: AlbumsViewModel!
    @IBOutlet weak var tableView: UITableView!
    var artist: Artist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTitle()
        setupViewModel()
    }
    
    private func setupTableView() {
        let reuseId = String.init(describing: AlbumTableViewCell.self)
        tableView.register(UINib(nibName: reuseId, bundle: Bundle.main), forCellReuseIdentifier: reuseId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
    }
    
    private func setupTitle() {
        if !artist.name.isEmpty {
            self.title = "Albums for: " + artist.name
        }
    }
    
    private func setupViewModel() {
        viewModel.backendService = ServiceRegistry.shared.backendService
        viewModel.output = self
        viewModel.artist = artist
        viewModel.search()
    }
    
    private func showAlbumDetails(for album: Album) {
        print(#function)
    }
}

extension AlbumsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let contains: Bool = indexPaths.contains { element in
            return self.viewModel.isLoading(for: element)
        }
        if contains {
            self.viewModel.search()
        }
    }
}

extension AlbumsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let album: Album? = self.viewModel.album(for: indexPath.row)
        let reuseId = String.init(describing: AlbumTableViewCell.self)
        let cell: AlbumTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for:indexPath) as! AlbumTableViewCell
        cell.setup(with: album)
//        if let album = album {
//            cell.viewTapBehaviour = ViewTapBehaviour.init(views: [cell.mainContainer], onTap: { [unowned self] (view: UIView) in
//
//            })
//        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.totalCount()
    }
}

extension AlbumsViewController: AlbumsViewModelOutput {
    func updated(viewModel: AlbumsViewModel) {
        self.tableView.reloadData()
    }
}
