//
//  ArtistSearchViewModel.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

protocol ArtistSearchViewModelOutput: class {
    func updated(viewModel: ArtistSearchViewModel)
}

class ArtistSearchViewModel: NSObject {
    weak var output: ArtistSearchViewModelOutput!
    var artists: [Artist] = []
    
    override init() {
        super.init()
    }
    
    func search(artist name: String) {
        var request = ArtistSearchRequest.init()
        request.artist = "cher"
        request.completion = { [unowned self] (artists: [Artist]) in
            self.artists = artists
            self.output.updated(viewModel: self)
        }
        ServiceRegistry.shared.backendService.execute(request: request)
    }
}
