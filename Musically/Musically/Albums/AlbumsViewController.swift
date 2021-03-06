//
//  AlbumsViewController.swift
//  Musically
//
//  Created by Martin on 10/2/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import UIKit

class AlbumsViewController: CommonViewController {
    @IBOutlet weak var dataProvider: AlbumsDataProvider!
    @IBOutlet weak var tableView: UITableView!
    var artist: Artist!
    private var tableViewDelegator: AlbumsTableViewDelegator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTitle()
        setupViewModel()
        installResetButton()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: AlbumTableViewCell.reuseId(), bundle: Bundle.main), forCellReuseIdentifier: AlbumTableViewCell.reuseId())
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableViewDelegator = AlbumsViewControllerFactory.delegator(dataProvider: dataProvider, navigationController: self.navigationController)
        tableViewDelegator.bind(tableView: tableView)
    }
    
    private func setupTitle() {
        if !artist.name.isEmpty {
            self.title = "Albums for: " + artist.name
        }
    }
    
    private func setupViewModel() {
        dataProvider.backendService = ServiceRegistry.shared.backendService
        dataProvider.dataSource.callback = { [unowned self] () -> Void in
            self.tableView.reloadData()
        }
        dataProvider.artist = artist
        dataProvider.search()
    }
    
    private func installResetButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Stored", style: .done, target: self, action: #selector(resetToStoredAlbums(sender:)))
    }
    
    @objc private func resetToStoredAlbums(sender: UIBarButtonItem) {
        //NotificationCenter.default.post(name: NSNotification.Name.resetToStoredAlbums, object: nil)
    }
}
