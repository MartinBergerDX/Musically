//
//  BackendServiceConfiguration.swift
//  Musically
//
//  Created by Martin on 1/17/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import Foundation

class BackendServiceConfiguration {
    let APIKey: String = "4ada9c636666c2d26556850f10f59121"
    let sharedSecret: String = "a6c18927ef5d6771e18b76db9bceffda"
    let baseUrl: String = "http://ws.audioscrobbler.com/2.0"
    let userAgent: UserAgent = UserAgent()
    let defaultTimeout: TimeInterval = 10
}
