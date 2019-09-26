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
    
    static func storyboardViewController<T: UIViewController>() -> T {
        let storyboard = UIStoryboard(name: T.storyboardName, bundle: nil)
        
        guard let vc = storyboard.instantiateInitialViewController() as? T else {
            fatalError("Could not instantiate initial storyboard with name: \(T.storyboardName)")
        }
        
        return vc
    }
}

extension UIViewController: Storyboardable { }
