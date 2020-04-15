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
    @IBOutlet weak var viewModel: ArtistSearchDataProvider!
    private var tableViewDelegator: ArtistSearchTableViewDelegator!
    private var factory: ArtistSearchRequestFactoryProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        factory = ArtistSearchFactory()
        setupTableView()
        setupViewModel()
        setupSearchController()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: ArtistTableViewCell.reuseId(), bundle: Bundle.main), forCellReuseIdentifier: ArtistTableViewCell.reuseId())
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableViewDelegator = factory.delegator(viewModel: viewModel, navigationController: self.navigationController)
        tableViewDelegator.bind(tableView: tableView)
    }
    
    private func setupViewModel() {
        viewModel.backendService = serviceRegistry().backendService
        viewModel.artists.callback = { [unowned self] () -> Void in
            print("reloading table")
            self.tableView.reloadData()
        }
        //viewModel.search()
    }
    
    private func setupSearchController() {
        let searchController = factory.searchController(updater: self)
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }
}

extension ArtistSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query: String = searchController.searchBar.text ?? ""
        viewModel.beginSearch(queryString: query)
    }
}
