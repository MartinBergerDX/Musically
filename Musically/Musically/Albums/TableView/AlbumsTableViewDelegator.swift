//
//  AlbumsTableViewDelegator.swift
//  Musically
//
//  Created by Martin on 1/17/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import UIKit

class AlbumsTableViewDelegator: NSObject, UITableViewDataSource, UITableViewDataSourcePrefetching {
    private let dataSource: AlbumsTableViewDataSource!
    private let prefetching: AlbumsTableViewPrefetching!
    
    init (dataSource: AlbumsTableViewDataSource, prefetching: AlbumsTableViewPrefetching) {
        self.dataSource = dataSource
        self.prefetching = prefetching
    }
    
    func bind(tableView: UITableView) {
        tableView.dataSource = self
        tableView.prefetchDataSource = self
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataSource.tableView(tableView, cellForRowAt: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections(in: tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.tableView(tableView, numberOfRowsInSection: section)
    }
    
    // MARK: UITableViewDataSourcePrefetching
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        prefetching.tableView(tableView, prefetchRowsAt: indexPaths)
    }
}
