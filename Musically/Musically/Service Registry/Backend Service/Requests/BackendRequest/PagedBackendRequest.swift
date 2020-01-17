//
//  PagedBackendRequest.swift
//  Musically
//
//  Created by Martin on 1/17/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation

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
