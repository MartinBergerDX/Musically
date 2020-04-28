//
//  QueueTestRequest.swift
//  MusicallyTests
//
//  Created by Martin on 4/27/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation
@testable import Musically

class QueueTestRequest: BackendRequest<Foo> {
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
