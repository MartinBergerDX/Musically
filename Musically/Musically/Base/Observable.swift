//
//  Observable.swift
//  Musically
//
//  Created by Martin on 1/19/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation

class Observable<DataType> {
    var callback: (() -> Void)?
    var value: DataType {
        didSet {
            DispatchQueue.main.async {
                self.callback?()
            }
        }
    }
    init(value: DataType) {
        self.value = value
    }
}
