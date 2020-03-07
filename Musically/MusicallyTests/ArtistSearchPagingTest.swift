//
//  ArtistSearchPagingTest.swift
//  MusicallyTests
//
//  Created by Martin on 2/12/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import XCTest
import Foundation
@testable import Musically

class ArtistSearchPagingTest: XCTestCase {
//    var serviceRegistry: ServiceRegistryProtocol
    var viewModel: ArtistSearchViewModel!
    
    override func setUp() {
        viewModel = ArtistSearchViewModel.init()
        viewModel.factory = MockArtistSearchRequestFactory()
        viewModel.backendService = MockBackendService.init()
    }

    override func tearDown() {
        viewModel = nil
    }
    
    func testFirstRun() {
        viewModel.beginSearch(queryString: "cher")
        XCTAssert(viewModel.artists.value.count == 30)
    }
}

class MockArtistSearchRequestFactory: ArtistSearchRequestFactoryProtocol {
    func produceRequest(artistQuery: String, page: Int) -> ArtistSearchRequest {
        let request = MockArtistSearchRequest.init(artistQuery: "test")
        let objects = Array.init(repeating: Artist.init(), count: 30)
        let pagination = RequestPaging.init(limit: RequestPaging.DefaultLimit, page: 1, total: 100)
        let result = ArtistSearchResult.init(artists: objects, pagination: pagination)
        request.objectsForPage = [result]
        return request
    }
}

class MockBackendService: BackendServiceProtocol {
    func enqueue(requests: [BackendRequestProtocol]) {
        
    }
    
    func enqueue(request: BackendRequestProtocol) {
        
    }
    
    let execution: MockBackendRequestExecution
    
    init() {
        self.execution = MockBackendRequestExecution.init()
    }
    
    func requestIterator() -> BackendRequestIterator {
        return BackendRequestIterator.null
    }
}

class MockBackendRequestExecution: BackendRequestExecutionProtocol {
    func execute(backendRequest:  BackendRequestProtocol) {
        backendRequest.onComplete(result: .success(Data.init()))
    }
}

class MockArtistSearchRequest: ArtistSearchRequest {
    var objectsForPage: [ArtistSearchResult] = []
    
    override func onComplete(result: Result<Data, Error>) {
        let filtered: [ArtistSearchResult] = objectsForPage.filter { (($0 as ArtistSearchResult).pagination.page == self.pagination.page) }
        completion?(.success(filtered.first!))
    }
}
