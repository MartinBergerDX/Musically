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
    private static let defaultQuery = "cher"
    private static let optimizedCount = 100 // needed because server can return large data sets
    weak var output: ArtistSearchViewModelOutput!
    private var artists: [Artist] = []
    private var currentQuery: String! = ArtistSearchViewModel.defaultQuery
    private var newQuery: String! = ArtistSearchViewModel.defaultQuery
    private var searching = false // mutated on main thread only
    private var page: Int = Pagination.defaultPage
    private var totalElements: Int = 100
    var backendService: BackendServiceProtocol!
    
    override init() {
        super.init()
    }
    
    func search() {
        guard !searching else {
            return
        }
        searching = true

        if queryUpdated() {
            page = Pagination.defaultPage
        }
        
        var request = ArtistSearchRequest.init()
        request.page = page
        request.artist = self.newQuery.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? self.newQuery
        request.completion = { [unowned self] (result) in
            self.searchFinished(with: result)
            self.output.updated(viewModel: self)
        }
        self.backendService.execute(request: request)
    }
    
    private func searchFinished(with result: Result<AlbumSearchResult, Error>) {
        switch result {
        case .success(let received):
            self.totalElements = received.pagination.total
            self.page += 1
            if queryUpdated() {
                self.artists = received.albums
                totalElements = ArtistSearchViewModel.optimizedCount
                currentQuery = newQuery
            } else {
                self.artists.append(contentsOf: received.albums)
            }
            
            break
        case .failure(let error):
            
            print(error)
            
            break
        }
        
        searching = false
    }
    
    func totalCount() -> Int {
        guard totalElements > 0 else {
            return ArtistSearchViewModel.optimizedCount
        }
        return totalElements
    }
    
    func artist(for index: Int) -> Artist? {
        guard index < artists.count else {
            return .none
        }
        return artists[index]
    }
    
    func isLoading(for indexPath: IndexPath) -> Bool {
        guard !self.artists.isEmpty else {
            return false
        }
        return indexPath.row > self.artists.count
    }
    
    private func queryUpdated() -> Bool {
        return currentQuery != newQuery
    }
}

extension ArtistSearchViewModel: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let query: String = searchController.searchBar.text ?? ArtistSearchViewModel.defaultQuery
        print("Searching with: " + query)
        newQuery = query
        search()
    }
}
