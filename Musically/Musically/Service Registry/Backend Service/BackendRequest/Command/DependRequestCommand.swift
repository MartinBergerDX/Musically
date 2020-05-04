//
//  DependRequestCommand.swift
//  Musically
//
//  Created by Martin on 5/4/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation

class DependRequestCommand<Origin, Destination>: BackendRequestCommandProtocol where Origin: BackendOperation, Origin: BackendRequestProtocol, Destination: BackendRequestProtocol {
    var destination: Destination!
    var mapping: MappingType!
    typealias MappingType = ((Origin, Destination) -> Void)
    
    init(destination: Destination, mapping: @escaping MappingType) {
        self.destination = destination
        self.mapping = mapping
    }
    
    func execute<T>(request: BackendRequest<T>) {
        if let r: Origin = request as? Origin {
            mapping(r, destination)
        }
    }
}
