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

class BackendServiceTest: XCTestCase {
    fileprivate var backendService: QueueTestBackendService!
    
    override func setUp() {
        let execution = QueueTestExecution.init()
        backendService = QueueTestBackendService.init(backendRequestExecution: execution)
    }

    override func tearDown() {
        
    }
    
    func testOnlyOne() {
        let exp = expectation(description: "completion")
        let req = QueueTestRequest.init(seconds: 0.2, completion: { exp.fulfill() })
        backendService.enqueue(request: req)
        waitForExpectations(timeout: 1)
        XCTAssert(req.state == .finished && backendService.currentOperationCount() == 0)
    }
    
    func testSeparate() {
        var requests: [QueueTestRequest] = []
        for _ in 0...10 {
            let exp = expectation(description: "completion")
            let req = QueueTestRequest.init(seconds: 0.2, completion: { exp.fulfill() })
            requests.append(req)
        }
        backendService.enqueue(requests: requests)
        waitForExpectations(timeout: 1)
        let filtered = requests.filter({ $0.state != .finished })
        XCTAssert(filtered.isEmpty && backendService.currentOperationCount() == 0)
    }
    
    func testChained() {
        var requests: [QueueTestRequest] = []
        for _ in 0...10 {
            let exp = expectation(description: "completion")
            let req = QueueTestRequest.init(seconds: 0.2, completion: { exp.fulfill() })
            requests.append(req)
        }
        backendService.enqueue(requests: requests)
        waitForExpectations(timeout: 1)
        let filtered = requests.filter({ $0.state != .finished })
        XCTAssert(filtered.isEmpty && backendService.currentOperationCount() == 0)
    }
}

class QueueTestExecution: BackendRequestExecutionProtocol {
    func execute(backendRequest: BackendRequestProtocol) {
        
    }
}

fileprivate
class QueueTestRequest: BackendRequest {
    init(seconds: Double, completion: @escaping () -> Void) {
        super.init()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            self.set(requestState: .finished)
            completion()
        }
    }
}

fileprivate class QueueTestBackendService: BackendService {
    func currentOperationCount() -> Int {
        return requestQueue.operationCount
    }
}
