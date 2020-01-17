//
//  AlbumDetailsRouter.swift
//  Musically
//
//  Created by Martin on 1/15/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import UIKit

class AlbumDetailsRouter {
    weak var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showAlbumDetails(for album: Album) {
        let vc = AlbumDetailsViewController.storyboardViewController()
        vc.album = album
        self.navigationController.pushViewController(vc, animated: true)
    }
}
