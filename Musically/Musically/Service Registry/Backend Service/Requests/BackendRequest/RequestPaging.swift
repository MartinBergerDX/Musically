//
//  Pagination.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

struct RequestPaging {
    private static let defaultLimit = 30
    private static let defaultPage = 1
    
    var limit: Int = RequestPaging.defaultLimit
    var page: Int = RequestPaging.defaultPage
    var total: Int = 0
    
    mutating func nextPage() {
        self.page += 1
    }
    
    mutating func reset() {
        self.page = RequestPaging.defaultPage
    }
    
    static let null = RequestPaging.init(limit: 0, page: 0, total: 0)
    
    static func == (left: RequestPaging, right: RequestPaging) -> Bool {
        return left.limit == right.limit && left.page == right.page && left.total == right.total
    }
}

extension RequestPaging {
    func arguments() -> String {
        if self == RequestPaging.null {
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
