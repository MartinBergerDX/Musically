//
//  ReuseIdentification.swift
//  Musically
//
//  Created by Martin on 1/15/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import UIKit

protocol ReusableObject {
    static func fileName() -> String!
    static func reuseId() -> String!
    static func nib() -> UINib!
}

extension ReusableObject {
    static func fileName() -> String! {
        return String.init(describing: self)
    }
    
    static func reuseId() -> String! {
        return String.init(describing: self)
    }
    
    static func nib() -> UINib! {
        let nibName: String = String.init(describing: self)
        return UINib(nibName: nibName, bundle: Bundle.main)
    }
}
