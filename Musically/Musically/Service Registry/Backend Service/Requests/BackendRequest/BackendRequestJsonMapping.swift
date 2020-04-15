//
//  BackendRequestJsonMapping.swift
//  Musically
//
//  Created by Martin on 1/19/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation

protocol BackendRequestJsonMapping {
    associatedtype DataType: Decodable, Initable
}

extension BackendRequestJsonMapping {
    func mappedObject(from data: Data) throws -> DataType {
        return try JSONDecoder().decode(DataType.self, from: data)
    }
    
    func mapJsonButReturnNullObjectOnMapException(from data: Data) -> DataType {
        do {
            return try mappedObject(from: data)
        } catch _ {
            let someErrorString: String = String(decoding: data, as: UTF8.self)
            print("Error parsing JSON response: " + someErrorString)
            return DataType.init()
        }
    }
}

//class BackendRequestJsonMapping2<T: Decodable> {
//    func mappedObject(from data: Data) throws -> T {
//        return try JSONDecoder().decode(T.self, from: data)
//    }
//
//    func mapJsonButReturnNullObjectOnMapException(from data: Data) -> T {
//        do {
//            return try mappedObject(from: data)
//        } catch _ {
//            let someErrorString: String = String(decoding: data, as: UTF8.self)
//            print("Error parsing JSON response: " + someErrorString)
//            return DataType.init()
//        }
//    }
//}
