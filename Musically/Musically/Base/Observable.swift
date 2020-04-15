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

//protocol ObservableCollectionProtocol {
//    associatedtype CollectionDataType: Any
//    var value: [CollectionDataType] { get set }
//    func count() -> Int
//    func object(at index: Int) -> CollectionDataType
//    func removeAll()
//    func append(contentsOf collection: inout [CollectionDataType])
//    func isEmpty() -> Bool
//}

class ObservableCollection {
    var callback: (() -> Void)?
    var value: [Any] {
        didSet {
            notify()
        }
    }
    
    init(value: [Any]) {
        self.value = value
    }
    
    func count() -> Int {
        return value.count
    }
    
    private func notify() {
        DispatchQueue.main.async {
            self.callback?()
        }
    }
    
//
//    func object(at index: Int) -> DataType {
//        return value[index]
//    }
//
//    func removeAll() {
//        value.removeAll()
//    }
//
//    func append(contentsOf collection: inout [DataType]) {
//        value.append(contentsOf: collection)
//    }
//
    func isEmpty() -> Bool {
        return value.isEmpty
    }
}
