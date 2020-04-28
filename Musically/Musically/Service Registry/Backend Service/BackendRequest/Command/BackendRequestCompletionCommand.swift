//
//  BackendRequestCompletionCommand.swift
//  Musically
//
//  Created by Martin on 4/27/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation

class BackendRequestCompletionCommand: BackendRequestCommandProtocol {
    var completion: (() -> Void)!
    
    init(callback: @escaping () -> Void) {
        self.completion = callback
    }
    
    func execute<T>(request: BackendRequest<T>) {
        completion()
    }
}
