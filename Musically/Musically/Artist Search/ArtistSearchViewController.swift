//
//  ArtistSearchViewController.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import UIKit

class ArtistSearchViewController: UIViewController, ArtistSearchViewModelOutput {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewModel: ArtistSearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.output = self
        self.viewModel.search(artist: "cher")
    }
    
    func updated(viewModel: ArtistSearchViewModel) {
        
    }
}
