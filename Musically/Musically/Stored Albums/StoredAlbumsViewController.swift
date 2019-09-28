//
//  ViewController.swift
//  Musically
//
//  Created by Martin on 9/25/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import UIKit

class StoredAlbumsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onSearch() {
        let asvc = ArtistSearchViewController.storyboardViewController(from: "Main")
        self.navigationController?.pushViewController(asvc, animated: true)
    }
}

