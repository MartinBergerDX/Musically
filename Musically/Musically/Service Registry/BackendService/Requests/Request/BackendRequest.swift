//
//  BackendRequest.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

protocol BackendRequest {
    var endpoint: String {get}
    var arguments: String {get}
    var method: String {get}
    func onComplete(result: Result<Data,Error>)
}
