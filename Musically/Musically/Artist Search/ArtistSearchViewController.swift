//
//  ArtistSearchViewController.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import UIKit

class ArtistSearchViewController: CommonViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewModel: ArtistSearchViewModel!
    private var tableViewDelegator: ArtistSearchTableViewDelegator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupViewModel()
        setupSearchController()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: ArtistTableViewCell.reuseId(), bundle: Bundle.main), forCellReuseIdentifier: ArtistTableViewCell.reuseId())
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableViewDelegator = ArtistSearchFactory.delegator(viewModel: viewModel, navigationController: self.navigationController)
        tableViewDelegator.bind(tableView: tableView)
    }
    
    private func setupViewModel() {
        self.viewModel.backendService = ServiceRegistry.shared.backendService
        self.viewModel.artists.callback = { [unowned self] () -> Void in
            print("reload data")
            self.tableView.reloadData()
        }
        self.viewModel.search()
    }
    
    private func setupSearchController() {
        let searchController = ArtistSearchFactory.searchController(viewModel: viewModel)
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }
}
