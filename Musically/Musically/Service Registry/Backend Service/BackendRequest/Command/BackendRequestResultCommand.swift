//
//  BackendRequestResultCommand.swift
//  Musically
//
//  Created by Martin on 4/27/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation

class BackendRequestResultCommand<DataType: BackendRequestDataType>: BackendRequestCommandProtocol {
    
    var completion: ((DataType) -> Void)?
    var failure: ((Error) -> Void)?

    func execute<T: BackendRequestDataType>(request: BackendRequest<T>) {
        if case .failure(let error) = request.result {
            failure?(error)
            return
        }
        completion?(request.value as! DataType)
    }
}
