//
//  Storyboardable.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

import UIKit

// https://codeburst.io/simpler-ios-storyboard-instantiation-97ca4bfb63bd

protocol Storyboardable: class {
    static var storyboardName: String { get }
}

extension Storyboardable where Self: UIViewController {
    static var storyboardName: String {
        return String(describing: self)
    }
    
    static func storyboardViewController(from storyboard: String) -> Self {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let storyboardId = String(describing: self)
        guard let vc = storyboard.instantiateViewController(withIdentifier: storyboardId) as? Self else {
            fatalError("Could not instantiate initial storyboard with name: \(storyboard)")
        }
        
        return vc
    }
}

extension UIViewController: Storyboardable {
    
}
