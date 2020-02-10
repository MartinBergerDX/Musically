//
//  ArtistSearchViewModel.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation
import UIKit

class ArtistSearchViewModel: NSObject {
    let artists: Observable<[Artist]> = Observable<[Artist]>.init(value: [])
    private static let defaultQuery = "cher"
    private static let optimizedCount = 100 // needed because server can return large data set > 2000
    private var currentQuery: String! = ArtistSearchViewModel.defaultQuery
    private var newQuery: String! = ArtistSearchViewModel.defaultQuery
    private var searching = false // mutated on main thread only
    private var paging: RequestPaging!
    private var totalElements: Int = 100
    var backendService: BackendServiceProtocol!
    
    override init() {
        super.init()
        self.paging = RequestPaging.init()
    }
    
    func search() {
        guard !backendService.scheduler.isArtistSearchInProgress() else {
            return
        }
//        guard !searching else {
//            return
//        }
//        searching = true
//
//        if queryUpdated() {
//            paging.reset()
//        }

        let request = ArtistSearchFactory.artistSearch(page: paging.page, artist: newQuery, completion: { [unowned self] (result) in
            self.searchFinished(with: result)
        })
        self.backendService.schedule(backendRequest: request)
    }
    
    private func searchFinished(with result: Result<ArtistSearchResult, Error>) {
        switch result {
        case .success(let model):
            paging.nextPage()
//            if queryUpdated() {
//                self.artists = model.artists
//                totalElements = ArtistSearchViewModel.optimizedCount
//                currentQuery = newQuery
//            } else {
//                totalElements = model.pagination.total
//                self.artists.append(contentsOf: model.artists)
//            }
            totalElements += model.artists.count
            self.artists.value.append(contentsOf: model.artists)
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
        guard index < artists.value.count else {
            return nil
        }
        return artists.value[index]
    }
    
    func isLoading(for indexPath: IndexPath) -> Bool {
        guard !self.artists.value.isEmpty else {
            return false
        }
        return indexPath.row > self.artists.value.count
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
