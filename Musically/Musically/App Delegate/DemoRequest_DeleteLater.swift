//
//  DemoRequest_DeleteLater.swift
//  Musically
//
//  Created by Martin on 4/27/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation

class DemoRequest {
    
    struct Foo: Codable, Initable {
        var value: Int!
    }
    
    class DemoReq1: BackendRequest<Foo> {
        
    }
    
    class DemoReq2: BackendRequest<Foo> {
        
    }
}
