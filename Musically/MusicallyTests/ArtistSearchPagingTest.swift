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

class MockBackendService: BackendServiceProtocol {
    func requestIterator() -> BackendRequestIterator {
        return BackendRequestIterator.null
    }
    
    func enqueue(request: BackendOperation) {
//        let page: Int = backendRequest.pagination.page
//        if let url = Bundle.main.url(forResource: "artist_search_1", withExtension: "json") {
//            let data: Data = try! Data.init(contentsOf: url)
//            backendRequest.onComplete(result: .success(data))
//        }
    }
}
