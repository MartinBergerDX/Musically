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
    func guaranteeObject(from data: Data) -> DataType {
        do {
            return try JSONDecoder().decode(DataType.self, from: data)
        } catch _ {
            let someErrorString: String = String(decoding: data, as: UTF8.self)
                print("Error parsing JSON response: " + someErrorString)
            return DataType.init()
        }
    }
}
