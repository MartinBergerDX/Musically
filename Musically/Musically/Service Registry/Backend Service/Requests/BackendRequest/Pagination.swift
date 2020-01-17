//
//  Pagination.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

struct Pagination {
    static let defaultLimit = 30
    static let defaultPage = 1
    var limit: Int = Pagination.defaultLimit
    var page: Int = Pagination.defaultPage
    var total: Int = 0
    
    mutating func nextPage() {
        self.page += 1
    }
}

protocol BaseRequest {
    associatedtype DataType
    var completion: (DataType) -> Void {get set}
}

protocol PagedBackendRequest {
    var limit: Int {get set}
    var page: Int {get set}
}

extension PagedBackendRequest {
    func pagingArguments() -> String {
        var args = "&"
        args.append("page=")
        args.append(String(self.page))
        args.append("&")
        args.append("limit=")
        args.append(String(self.limit))
        return args
    }
}
