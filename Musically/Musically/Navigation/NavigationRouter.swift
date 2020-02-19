//
//  NavigationRouter.swift
//  Musically
//
//  Created by Martin on 1/17/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import UIKit

protocol NavigationRouterProtocol {
    associatedtype DataType
    func navigate(with modelObject: DataType)
}

class NavigationRouter<ModelType: Any, ViewController: CommonViewController>: NavigationRouterProtocol {
    weak var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigate(with modelObject: ModelType) {
        let vc = ViewController.storyboardViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
