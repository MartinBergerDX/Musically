//
//  ArtistSearchViewModel.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation
import UIKit

protocol ArtistSearchViewModelOutput: class {
    func updated(viewModel: ArtistSearchViewModel)
}

class ArtistSearchViewModel: NSObject {
    weak var output: ArtistSearchViewModelOutput!
    private var artists: [Artist] = []
    private var currentSearchText: String! = "a"
    private var searchInProgress = false // mutated on main thread only
    private var page = Pagination.init()
    
    override init() {
        super.init()
    }
    
    func search(artist name: String) {
        guard searchInProgress == false else {
            return
        }
        searchInProgress = true
        
        var request = ArtistSearchRequest.init()
        request.artist = name
        request.completion = { [unowned self] (artists: [Artist]) in
            self.artists = artists
            self.output.updated(viewModel: self)
            self.searchFinished(with: name)
        }
        ServiceRegistry.shared.backendService.execute(request: request)
    }
    
    private func searchFinished(with search: String) {
        searchInProgress = false
        if search != self.currentSearchText {
            self.search(artist: self.currentSearchText)
        }
    }
    
    func count() -> Int {
        return self.artists.count
    }
    
    func artist(for index: Int) -> Artist {
        return artists[index]
    }
    
    private func resetPage() {
        self.page = Pagination.init()
    }
}

extension ArtistSearchViewModel: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        resetPage()
        var searchText = (searchController.searchBar.text ?? "")
        if (searchText.count == 0) {
            searchText = "a"
        }
        self.currentSearchText = searchText
        print("Searching with: " + searchText)
        search(artist: searchText)
    }
}
