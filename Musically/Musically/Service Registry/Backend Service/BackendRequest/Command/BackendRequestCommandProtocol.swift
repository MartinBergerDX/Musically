//
//  BackendRequestCommandProtocol.swift
//  Musically
//
//  Created by Martin on 5/1/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation

public typealias BackendRequestDataType = Decodable & Initable

protocol BackendRequestCommandProtocol {
    func execute<T: BackendRequestDataType>(request: BackendRequest<T>)
}
