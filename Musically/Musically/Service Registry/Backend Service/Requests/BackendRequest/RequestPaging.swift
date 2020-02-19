//
//  Pagination.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

struct RequestPaging {
    static let DefaultLimit = 30
    static let DefaultPage = 1
    
    var limit: Int = RequestPaging.DefaultLimit
    var page: Int = RequestPaging.DefaultPage
    var total: Int = 0
    
    mutating func nextPage() {
        self.page += 1
    }
    
    mutating func reset() {
        self.page = RequestPaging.DefaultPage
    }
    
    static let Null = RequestPaging.init(limit: 0, page: 0, total: 0)
    
    static func == (left: RequestPaging, right: RequestPaging) -> Bool {
        return left.limit == right.limit && left.page == right.page && left.total == right.total
    }
    
    
}

extension RequestPaging {
    func arguments() -> String {
        if self == RequestPaging.Null {
            return nullArguments()
        }
        var args = "&"
        args.append("page=")
        args.append(String(self.page))
        args.append("&")
        args.append("limit=")
        args.append(String(self.limit))
        return args
    }
    
    private func nullArguments() -> String { "" }
}
