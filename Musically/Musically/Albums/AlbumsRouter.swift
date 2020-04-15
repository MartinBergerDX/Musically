//
//  AlbumsRouter.swift
//  Musically
//
//  Created by Martin on 1/17/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import UIKit

class AlbumsRouter {
    weak var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showAlbums(for artist: Artist) {
        let vc = AlbumsViewController.storyboardViewController()
        vc.artist = artist
        self.navigationController.pushViewController(vc, animated: true)
    }
}
