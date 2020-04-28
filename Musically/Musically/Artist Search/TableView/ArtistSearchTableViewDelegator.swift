//
//  ArtistSearchTableViewDelegator.swift
//  Musically
//
//  Created by Martin on 1/17/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import UIKit

class ArtistSearchTableViewDelegator: NSObject, UITableViewDataSource, UITableViewDataSourcePrefetching {
    private let dataSource: ArtistSearchTableViewDataSource!
    private let prefetching: ArtistSearchTableViewPrefetching!
    
    init (dataSource: ArtistSearchTableViewDataSource, prefetching: ArtistSearchTableViewPrefetching) {
        self.dataSource = dataSource
        self.prefetching = prefetching
    }
    
    func bind(tableView: UITableView) {
        tableView.dataSource = self
        tableView.prefetchDataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataSource.tableView(tableView, cellForRowAt: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections(in: tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.tableView(tableView, numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        prefetching.tableView(tableView, prefetchRowsAt: indexPaths)
    }
}
