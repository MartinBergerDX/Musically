//
//  BackendServiceRequestDelegation.swift
//  MusicallyTests
//
//  Created by Martin on 4/27/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import XCTest
@testable import Musically

class BackendServiceRequestDelegation: XCTestCase {
    fileprivate var backendService: BackendService!
    fileprivate var consumer: RequestDelegationTestConsumer!

    override func setUp() {
        consumer = RequestDelegationTestConsumer()
        backendService = BackendService.init(consumer: consumer)
    }

    func testPassingData1() {
        let r2 = R2()
        let e2 = expectation(description: "completion2")
        let c2 = DelegationCommand<Foo>.init { (v: Foo) in
            e2.fulfill()
        }
        r2.add(command: c2)
        
        let r1 = R1()
        let e1 = expectation(description: "completion1")
        let c1 = DelegationCommand<Foo>.init { (v: Foo) in
            r2.receivedFromR1 = v
            e1.fulfill()
        }
        r1.add(command: c1)
        r2.addDependency(r1)
        
        backendService.enqueue(requests: [r1, r2])
        waitForExpectations(timeout: 1)
        XCTAssert(r2.receivedFromR1.value == 1)
    }
    
    func testPassingData2() {
        let r1 = R1()
        let e1 = expectation(description: "completion1")
        let c1 = DelegationCommand<Foo>.init { (v: Foo) in
            e1.fulfill()
        }
        r1.add(command: c1)
        
        let r2 = R2()
        let e2 = expectation(description: "completion2")
        let c2 = DelegationCommand<Foo>.init { (v: Foo) in
            e2.fulfill()
        }
        r2.add(command: c2)
        
        let r3 = R3()
        let e3 = expectation(description: "completion3")
        let c3 = DelegationCommand<Foo>.init { (v: Foo) in
            e3.fulfill()
        }
        r3.add(command: c3)
        
        let r4 = R4()
        r4.r1 = r1
        r4.r2 = r2
        r4.r3 = r3
        let e4 = expectation(description: "completion4")
        let c4 = DelegationCommand<Foo>.init { (v: Foo) in
            e4.fulfill()
        }
        r4.add(command: c4)
        r4.addDependency(r1)
        r4.addDependency(r2)
        r4.addDependency(r3)
        
        backendService.enqueue(requests: [r1, r2, r3, r4])
        waitForExpectations(timeout: 1)
        XCTAssert(r4.r1.value!.value == 1 && r4.r2.value!.value == 2 && r4.r3.value!.value == 3)
    }
    
    func testPassingData3() {
        let r1 = R1()
        r1.name = "R1"
        let e1 = expectation(description: "completion1")
        let c1 = DelegationCommand<Foo>.init { (v: Foo) in
            e1.fulfill()
        }
        r1.add(command: c1)
        
        let r2 = R2()
        r2.name = "R2"
        let e2 = expectation(description: "completion2")
        let c2 = DelegationCommand<Foo>.init { (v: Foo) in
            e2.fulfill()
        }
        r2.add(command: c2)
        r2.dependOn(originRequest: r1) { (origin: R1, dest: R2) in
            dest.receivedFromR1 = origin.value
        }
        
        let r3 = R3()
        r3.name = "R3"
        let e3 = expectation(description: "completion3")
        let c3 = DelegationCommand<Foo>.init { (v: Foo) in
            e3.fulfill()
        }
        r3.add(command: c3)
        r3.dependOn(originRequest: r2) { (origin: R2, dest: R3) in
            dest.receivedFromR2 = origin.value
        }
        
        backendService.enqueue(requests: [r1, r2, r3])
        waitForExpectations(timeout: 1)
        XCTAssert(r2.receivedFromR1.value == r1.value!.value)
        XCTAssert(r3.receivedFromR2.value == r2.value!.value)
    }
}

fileprivate
class R1: BackendRequest<Foo> {
    override func onComplete() {
        value = Foo.init(value: 1)
    }
}

fileprivate
class R2: BackendRequest<Foo> {
    var receivedFromR1: Foo!
    override func onComplete() {
        value = Foo.init(value: 2)
    }
}

fileprivate
class R3: BackendRequest<Foo> {
    var receivedFromR2: Foo!
    override func onComplete() {
        value = Foo.init(value: 3)
    }
}

fileprivate
class R4: BackendRequest<Foo> {
    var receivedFromR3: Foo!
    var r1: BackendRequest<Foo>!
    var r2: BackendRequest<Foo>!
    var r3: BackendRequest<Foo>!
    override func onComplete() {
        value = Foo.init(value: 4)
    }
}

fileprivate
class DelegationCommand<DataType: BackendRequestDataType>: BackendRequestCommandProtocol {
    func execute<T>(request: BackendRequest<T>) {
        completion(request.value! as! DataType)
    }
    
    var completion: ((DataType) -> Void)!
    init(completion: @escaping (DataType) -> Void) {
        self.completion = completion
    }
}

fileprivate
class RequestDelegationTestConsumer: BackendRequestConsumerProtocol {
    func execute(backendRequest: BackendRequestProtocol) {
        backendRequest.set(requestState: .finished)
        backendRequest.set(result: .success(Data()))
        backendRequest.onComplete()
        DispatchQueue.main.async {
            backendRequest.executeCommands()
        }
    }
}
