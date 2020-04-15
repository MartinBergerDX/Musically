//
//  MockArtistSearchDataProvider.swift
//  MusicallyTests
//
//  Created by Martin on 4/4/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation
@testable import Musically

class MockArtistSearchDataProvider: ArtistSearchDataProvider {
    override func callService() {
        let request = MockArtistSearchRequest.init(artistQuery: newQuery, page: paging.page)
        let command = request.makeCompletionCommand(success: { (result) in
            self.searchFinished(with: result)
        }) { (error) in
            self.handleServiceError(error: error)
        }
        request.add(command: command)
        self.backendService.enqueue(request: request)
    }
}
