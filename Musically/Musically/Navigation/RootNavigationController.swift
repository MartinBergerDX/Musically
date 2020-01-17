//
//  RootNavigationController.swift
//  Musically
//
//  Created by Martin on 10/7/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeNotifications()
    }
    
    private func subscribeNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(resetToStoredAlbums(notification:)), name: NSNotification.Name.resetToStoredAlbums, object: nil)
    }
    
    @objc private func resetToStoredAlbums(notification: NSNotification) {
        let storedAlbums = StoredAlbumsViewController.storyboardViewController()
        setViewControllers([storedAlbums], animated: true)
    }
}

extension Notification.Name {
    static let resetToStoredAlbums = Notification.Name("resetToStoredAlbums")
}
