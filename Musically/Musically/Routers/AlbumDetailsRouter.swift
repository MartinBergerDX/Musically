//
//  AlbumDetailsRouter.swift
//  Musically
//
//  Created by Martin on 1/15/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import UIKit

class AlbumDetailsRouter {
    let navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showAlbumDetails(for album: Album) {
        let vc = AlbumDetailsViewController.storyboardViewController(from: "Main")
        vc.album = album
        self.navigationController.pushViewController(vc, animated: true)
    }
}
