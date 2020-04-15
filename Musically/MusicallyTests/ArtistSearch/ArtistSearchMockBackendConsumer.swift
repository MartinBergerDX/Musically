//
//  ArtistSearchMockBackendConsumer.swift
//  MusicallyTests
//
//  Created by Martin on 4/4/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation
@testable import Musically

class ArtistSearchMockBackendConsumer: BackendRequestConsumerProtocol {
    func execute(backendRequest: BackendRequestProtocol) {
        backendRequest.set(requestState: .finished)
        backendRequest.set(result: Result.success(ObjectFromJsonFile<ArtistSearchResult>.data(from: "ArtistBatchOf30")))
        backendRequest.onComplete()
    }
}
