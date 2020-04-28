//
//  QueueTestConsumer.swift
//  MusicallyTests
//
//  Created by Martin on 4/27/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation
@testable import Musically

struct Foo: Codable, Initable {
    var value: Int!
}

class QueueTestConsumer: BackendRequestConsumerProtocol {
    var jsonData: Data!
    func execute(backendRequest: BackendRequestProtocol) {
        backendRequest.set(requestState: .finished)
        backendRequest.set(result: .success(self.jsonData))
        backendRequest.onComplete()
        DispatchQueue.main.async {
            backendRequest.executeCommands()
        }
    }
}
