//
//  URLBuilderTests.swift
//  MusicallyTests
//
//  Created by Martin on 12/10/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import XCTest
import Foundation
@testable import Musically

class URLBuilderTests: XCTestCase {
    var builder: URLBuilder!
    override func setUp() {
        builder = URLBuilder()
    }

    override func tearDown() {
        
    }
    
    func testAppendRootSuceeds() {
        builder.add(root: "root")
        XCTAssert(builder.product().count > 0)
    }
    
    func testEmptyRootContinues() {
        builder.add(root: "")
        XCTAssert(builder.product() == "")
    }
}
