//
//  PagedDataSourceUsage.swift
//  Musically
//
//  Created by Martin on 4/4/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation

class DataSourcePagedUsage {
    private var dataSource: ObservableCollection!
    
    init(with dataSource: ObservableCollection) {
        self.dataSource = dataSource
    }
    
    func nearlySpent(for indexPath: IndexPath) -> Bool {
        guard !dataSource.isEmpty() else {
            return false
        }
        let lastIndex = max(dataSource.count() - 1, 0)
        let offsetBeforeEnd = 10
        let indexLimitBeforeEnd = lastIndex - offsetBeforeEnd
        return indexPath.row < indexLimitBeforeEnd
    }
}
