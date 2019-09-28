//
//  Pagination.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

struct Pagination {
    var limit: Int = 30
    var page: Int = 1
    
    mutating func nextPage() {
        self.page += 1
    }
    
    init() {
        
    }
}

protocol BaseRequest {
    associatedtype DataType
    var completion: (DataType) -> Void {get set}
}

protocol PagedBackendRequest {
    associatedtype DataType
    var pagination: Pagination {get set}
    var completion: ([DataType]) -> Void {get set}
}

extension PagedBackendRequest {
    func pagingArguments() -> String {
        var args = "&"
        args.append("page=")
        args.append(String(self.pagination.page))
        args.append("&")
        args.append("limit=")
        args.append(String(self.pagination.limit))
        return args
    }
}
