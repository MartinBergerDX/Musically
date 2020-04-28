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
    fileprivate var vm: DataProviderTest!
    
    override func setUp() {
        vm = DataProviderTest()
        vm.backendService = BackendService.init(consumer: ArtistSearchMockBackendConsumer())
    }

    override func tearDown() {
        vm = nil
    }
    
    func testLoadSinglePage() {
        vm.exp = XCTestExpectation.init(description: "exp")
        vm.beginSearch(queryString: "test")
        wait(for: [vm.exp], timeout: 1)
        XCTAssert(vm.totalCount() == BatchCount)
    }
    
//    func testLoadFivePages() {
//        var exps: [XCTestExpectation] = []
//        for _ in 1...5 {
//            vm.exp = XCTestExpectation.init(description: "exp")
//            vm.beginSearch(queryString: "test")
//            exps.append(vm.exp)
//        }
//        wait(for: exps, timeout: 2)
//        XCTAssert(vm.totalCount() == (BatchCount * 5))
//    }
}

fileprivate
class DataProviderTest: ArtistSearchDataProvider {
    var exp: XCTestExpectation!
    override func searchFinished(with result: ArtistSearchResult) {
        super.searchFinished(with: result)
        exp.fulfill()
    }
}
