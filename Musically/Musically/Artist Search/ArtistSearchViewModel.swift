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
    var factory: ArtistSearchRequestFactoryProtocol!
    let artists: Observable<[Artist]> = Observable<[Artist]>.init(value: [])
    
    private static let DefaultQuery = "cher"
    //private static let optimizedCount = 100 // needed because server can return large data set > 2000
    private var currentQuery: String! = ArtistSearchViewModel.DefaultQuery
    private var newQuery: String! = ArtistSearchViewModel.DefaultQuery
    private var searching = false // mutated on main thread only
    private var paging: RequestPaging!
    //private var totalElements: Int = 100
    var backendService: BackendServiceProtocol!
    
    override init() {
        super.init()
        self.paging = RequestPaging.init()
    }
    
    func search() {
//        guard ArtistSearchCheck().isInProgress(iterator: backendService.requestIterator()) else {
//            return
//        }
        
        let loadingElements = Array.init(repeating: Artist(), count: RequestPaging.DefaultLimit)
        artists.value.append(contentsOf: loadingElements)

        //let request = ArtistSearchRequest.init(artistQuery: newQuery, page: paging.page)
        let request = factory.produceRequest(artistQuery: newQuery, page: paging.page)
        request.completion = { [unowned self] (result) in
            self.searchFinished(with: result)
        }
        
        self.backendService.enqueue(request: request)
    }
    
    private func searchFinished(with result: Result<ArtistSearchResult, Error>) {
        switch result {
        case .success(let model):
            print("arrived: \(model.artists.count)")
            paging.nextPage()
//            if queryUpdated() {
//                self.artists = model.artists
//                totalElements = ArtistSearchViewModel.optimizedCount
//                currentQuery = newQuery
//            } else {
//                totalElements = model.pagination.total
//                self.artists.append(contentsOf: model.artists)
//            }
            
//            totalElements += model.artists.count
//            self.artists.value.append(contentsOf: model.artists)
//            let range = ((model.pagination.page-1) * RequestPaging.DefaultLimit)...(((model.pagination.page-1) * RequestPaging.DefaultLimit) + (RequestPaging.DefaultLimit - 1))
//
//            artists.value.replaceSubrange(model.pagination.calculateReplaceRange(count: model.artists.count), with: model.artists)
            let range = calculateReplaceRange(page: model.pagination.page, count: model.artists.count)
            artists.value.replaceSubrange(range, with: model.artists)
            break
        case .failure(let error):
            print(error)
            break
        }
        searching = false
    }
    
    func totalCount() -> Int {
        print(artists.value.count)
        return artists.value.count
//        guard totalElements > 0 else {
//            return ArtistSearchViewModel.optimizedCount
//        }
//        return totalElements
    }
    
    func artist(for index: Int) -> Artist? {
//        guard index < artists.value.count else {
//            return nil
//        }
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
    
    func beginSearch(queryString: String) {
        print("Searching with: " + queryString)
        newQuery = queryString
        search()
    }
}

extension ArtistSearchViewModel: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let query: String = searchController.searchBar.text ?? ArtistSearchViewModel.DefaultQuery
        beginSearch(queryString: query)
    }
}

class ArtistSearchCheck {
    func isInProgress(iterator: BackendRequestIterator) -> Bool {
        while let element = iterator.next() {
            if element is ArtistSearchRequest {
                return true
            }
        }
        return false
    }
}
