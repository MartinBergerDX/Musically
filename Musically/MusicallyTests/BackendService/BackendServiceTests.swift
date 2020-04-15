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
    fileprivate var consumer: QueueTestConsumer!

    override func setUp() {
        consumer = QueueTestConsumer()
        backendService = QueueTestBackendService.init(consumer: consumer)
    }

    override func tearDown() {

    }

    func testOnlyOne() {
        let exp = expectation(description: "completion")
        let command = BackendRequestCompletionCommand.init {
            exp.fulfill()
        }
        let req = QueueTestRequest.init(deadline: 0.2)
        consumer.jsonData = "1".data(using: .utf8)!
        req.add(command: command)
        backendService.enqueue(request: req)
        waitForExpectations(timeout: 0.5)
        XCTAssert(req.state == .finished && backendService.currentOperationCount() == 0)
    }

    func testSeparate() {
        var requests: [QueueTestRequest] = []
        for _ in 0...10 {
            let exp = expectation(description: "completion")
            let command = BackendRequestCompletionCommand.init {
                exp.fulfill()
            }
            let seconds: Double = Double(arc4random() % 10) * 0.1
            let request = QueueTestRequest.init(deadline: seconds)
            request.add(command: command)
            requests.append(request)
        }
        consumer.jsonData = "1".data(using: .utf8)!
        backendService.enqueue(requests: requests)
        waitForExpectations(timeout: 1.2)
        let filtered = requests.filter({ $0.state != .finished })
        XCTAssert(filtered.isEmpty && backendService.currentOperationCount() == 0)
    }

    func testChainedRequests() {
        consumer.jsonData = "1".data(using: .utf8)!

        let expOp1 = expectation(description: "op1")
        let command1 = BackendRequestCompletionCommand.init {
            expOp1.fulfill()
        }
        let req1 = QueueTestRequest.init(deadline: 0.6)
        req1.identifier = "op1"
        req1.add(command: command1)

        let expOp2 = expectation(description: "op2")
        let command2 = BackendRequestCompletionCommand.init {
            expOp2.fulfill()
        }
        let req2 = QueueTestRequest.init(deadline: 0.2)
        req1.identifier = "op2"
        req2.add(command: command2)
        req2.addDependency(req1)

        backendService.enqueue(requests: [req1, req2])
        waitForExpectations(timeout: 1)
        XCTAssert(req1.state == .finished && backendService.currentOperationCount() == 0)
    }
}

class QueueTestConsumer: BackendRequestConsumerProtocol {
    var jsonData: Data!
    func execute(backendRequest: BackendRequestProtocol) {
        //DispatchQueue.main.async { [unowned self] in
            backendRequest.set(requestState: .finished)
            backendRequest.set(result: .success(self.jsonData))
            backendRequest.onComplete()
        //}
    }
}

fileprivate
class QueueTestRequest: BackendRequest<Int> {
    var identifier: String?
    override var description: String {
        return identifier ?? ""
    }
    var deadline: Double = 0.2
    init(deadline: Double) {
        self.deadline = deadline
        super.init()
    }

    override func onComplete() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + deadline) {
            if let _ = self.identifier {
                print("Operation completing: " + self.description)
            }
            super.onComplete()
        }
    }
}

fileprivate class QueueTestBackendService: BackendService {
    func currentOperationCount() -> Int {
        return requestQueue.operationCount
    }

    override func setup(requestQueue: OperationQueue) {
        requestQueue.name = "[TEST] Backend Service request serial queue"
        requestQueue.maxConcurrentOperationCount = 10
        requestQueue.underlyingQueue = DispatchQueue.global()
    }
}
