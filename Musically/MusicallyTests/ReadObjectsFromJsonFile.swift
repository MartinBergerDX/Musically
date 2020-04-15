//
//  ReadObjectsFromJsonFile.swift
//  MusicallyTests
//
//  Created by Martin on 4/4/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation

class ObjectFromJsonFile<T> where T: Decodable {
    static func convert(filename: String) -> T {
        let result = try! JSONDecoder().decode(T.self, from: data(from: filename))
        return result
    }
    
    static func data(from filename: String) -> Data {
        let bundle = Bundle.init(for: ArtistSearchPagingTest.self)
        let path = bundle.path(forResource: filename, ofType: "json")!
        let data = try! Data.init(contentsOf: URL(fileURLWithPath: path))
        return data
    }
}
