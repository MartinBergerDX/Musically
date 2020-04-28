//
//  BackendOperation.swift
//  Musically
//
//  Created by Martin on 1/19/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation

class BackendOperation: Operation {
    var execution: BackendRequestConsumerProtocol!
    
    override func main() {
        execution.execute(backendRequest: (self as! BackendRequestProtocol))
    }
}


class BackendOperation_Not_Used: Operation {
    private let stateQueue = DispatchQueue(label: "com.musically.backend.request.state", attributes: .concurrent)
    private var mExecuting = false
    private var mFinished = false
    var execution: BackendRequestConsumerProtocol!
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isExecuting: Bool {
        get {
            return stateQueue.sync { mExecuting }
        } set {
            willChangeValue(forKey: "executing")
            stateQueue.sync(flags: .barrier, execute: {
                mExecuting = newValue
            })
            didChangeValue(forKey: "executing")
        }
    }
    
    override var isFinished: Bool {
        get {
            return stateQueue.sync { mFinished }
        } set {
            willChangeValue(forKey: "finished")
            stateQueue.sync(flags: .barrier, execute: {
                mFinished = newValue
            })
            didChangeValue(forKey: "finished")
        }
    }
    
    override func start() {
        if (isCancelled || isFinished || isExecuting) {
            return
        }
        isExecuting = true
        main()
    }
    
    func finishOperation() {
        isFinished = true
    }
}
