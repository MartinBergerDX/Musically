//
//  URLBuilder.swift
//  Musically
//
//  Created by Martin on 12/10/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

class URLBuilder {
    private static let empty = ""
    private static let argument = "?"
    private var urlString: String!
    
    init() {
        urlString = URLBuilder.empty
    }
    
    func add(root: String) {
        guard root.count > 0 else {
            return
        }
        urlString = root
        urlString.append(URLBuilder.argument)
    }
    
    func add(key: String, value: String) {
        
    }
    
    public func product() -> String {
        return urlString
    }
}
