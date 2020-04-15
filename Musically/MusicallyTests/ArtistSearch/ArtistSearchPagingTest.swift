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
    private let BatchCount: Int = 30
    var vm: ArtistSearchDataProvider!
    
    override func setUp() {
        vm = ArtistSearchDataProvider()
        vm.backendService = BackendService.init(consumer: ArtistSearchMockBackendConsumer())
    }

    override func tearDown() {
        vm = nil
    }
    
    func testLoadSinglePage() {
        vm.beginSearch(queryString: "test")
        XCTAssert(vm.totalCount() == BatchCount)
    }
    
    func loadFivePages() {
        for _ in 1...5 {
            vm.beginSearch(queryString: "test")
        }
        XCTAssert(vm.totalCount() == (BatchCount * 5))
    }
}
