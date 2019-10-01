//
//  ArtistSearchViewController.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import UIKit

class ArtistSearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewModel: ArtistSearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        self.viewModel.backendService = ServiceRegistry.shared.backendService
        self.viewModel.output = self
        self.viewModel.search()
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self.viewModel
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search artists"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }
    
    private func setupTableView() {
        let reuseId = String.init(describing: ArtistTableViewCell.self)
        self.tableView.register(UINib(nibName: reuseId, bundle: Bundle.main), forCellReuseIdentifier: reuseId)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 60
    }
}

extension ArtistSearchViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let contains: Bool = indexPaths.contains { element in
            return self.viewModel.isLoading(for: element)
        }
        if contains {
            self.viewModel.search()
        }
    }
}

extension ArtistSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("Cell for index: " + String(indexPath.row))
        let artist: Artist? = self.viewModel.artist(for: indexPath.row)
        let reuseId = String.init(describing: ArtistTableViewCell.self)
        let cell: ArtistTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for:indexPath) as! ArtistTableViewCell
        cell.setup(with: artist)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.totalCount()
    }
}

extension ArtistSearchViewController: ArtistSearchViewModelOutput {
    func updated(viewModel: ArtistSearchViewModel) {
        self.tableView.reloadData()
    }
}
