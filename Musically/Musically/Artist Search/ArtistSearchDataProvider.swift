//
//  ArtistSearchDataProvider.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation
import UIKit

class ArtistSearchDataProvider: NSObject {
    let artists: ObservableCollection
    var backendService: BackendServiceProtocol!
    private var paging: RequestPaging!
    private var currentSearch: CurrentSearch!
    private var searchQueryState: SearchQueryState!
    private var dataSourceUsage: DataSourcePagedUsage!
    
    override init() {
        artists = ObservableCollection(value: [])
        dataSourceUsage = DataSourcePagedUsage.init(with: artists)
        currentSearch = CurrentSearch()
        searchQueryState = SearchQueryState()
        super.init()
        self.paging = RequestPaging.init()
    }
    
    func search() {
        guard !currentSearch.isInProgress(iterator: backendService.requestIterator(), page: paging.page) else {
            return
        }
        if searchQueryState.queryUpdated() {
            paging.reset()
        } else {
            paging.nextPage()
        }
        searchQueryState.update()
        callService()
    }
    
    func callService() {
        let request = makePagedRequest()
        self.backendService.enqueue(request: request)
    }
    
    func makePagedRequest() -> BackendOperation {
        let request = ArtistSearchRequest.init(artistQuery: searchQueryState.newQuery, page: paging.page)
        let command = request.makeCompletionCommand(success: { (result) in
            self.searchFinished(with: result)
        }) { (error) in
            print("error getting artists: " + error.localizedDescription)
        }
        request.add(command: command)
        return request
    }
    
    func searchFinished(with result: ArtistSearchResult) {
        print("arrived: \(result.artists.count)")
        if result.pagination.page == RequestPaging.DefaultPage {
            artists.value.removeAll()
        }
        let cellViewModels = result.artists.map({ ArtistSearchCellViewModel(artist: $0) })
        artists.value.append(contentsOf: cellViewModels)
    }
    
    func totalCount() -> Int {
        return artists.value.count
    }
    
    func viewModel(for index: Int) -> ArtistSearchCellViewModelProtocol {
        return artists.value[index] as! ArtistSearchCellViewModelProtocol
    }
    
    func isNearEnd(for indexPath: IndexPath) -> Bool {
        return dataSourceUsage.nearlySpent(for: indexPath)
    }
    
    func beginSearch(queryString: String) {
        guard queryString.count > 0 else {
            return
        }
        let query = queryString.count > 0 ? queryString : SearchQueryState.DefaultQuery
        print("Searching with: " + query)
        searchQueryState.newQuery = query
        search()
    }
}
