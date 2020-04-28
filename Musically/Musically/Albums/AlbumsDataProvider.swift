//
//  AlbumsDataProvider.swift
//  Musically
//
//  Created by Martin on 10/2/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

class AlbumsDataProvider: NSObject {
    let dataSource: ObservableCollection
    var backendService: BackendServiceProtocol!
    private var paging: RequestPaging!
    private var currentSearch: CurrentSearch!
    private var searchQueryState: SearchQueryState!
    private var dataSourceUsage: DataSourcePagedUsage!
    var artist: Artist!
    
    override init() {
        dataSource = ObservableCollection(value: [])
        dataSourceUsage = DataSourcePagedUsage.init(with: dataSource)
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
        let request = AlbumRequest.init(artistName: artist.name, mbid: artist.mbid, page: paging.page)
        let command = request.makeCompletionCommand(success: { (result) in
            self.searchFinished(with: result)
        }) { (error) in
            self.handleServiceError(error: error)
        }
        request.add(command: command)
        return request
    }
    
    func searchFinished(with result: AlbumsResult) {
        if result.pagination.page == RequestPaging.DefaultPage {
            dataSource.value.removeAll()
        }
        let cellViewModels = result.albums.map({ AlbumCellViewModel(album: $0) })
        dataSource.value.append(contentsOf: cellViewModels)
    }
    
    func handleServiceError(error: Error) {
        print("error getting artists: " + error.localizedDescription)
    }
    
    func totalCount() -> Int {
        return dataSource.value.count
    }
    
    func viewModel(for index: Int) -> AlbumCellViewModel {
        return dataSource.value[index] as! AlbumCellViewModel
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

//protocol AlbumsViewModelOutput: class {
//    func updated(viewModel: AlbumsDataProvider)
//}
//
//class AlbumsDataProvider: NSObject {
//    private static let optimizedCount = 100 // needed because server can return large data sets
//    weak var output: AlbumsViewModelOutput!
//    private var albums: [Album] = []
//    private var searching = false // mutated on main thread only
//    private var paging: RequestPaging!
//    private var totalElements: Int = 100
//    var backendService: BackendServiceProtocol!
//    var artist: Artist!
//
//    override init() {
//        super.init()
//        paging = RequestPaging.init()
//    }
//
//    func search() {
//        guard !searching else {
//            return
//        }
//        searching = true
//
//        let artistName = artist.name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
//        let mbid = artist.mbid.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
//        let request = AlbumRequest.init(artistName: artistName, mbid: mbid)
//        request.pagination.page = paging.page
//        request.completion = { [unowned self] (result) in
//            self.searchFinished(with: result)
//            self.output.updated(viewModel: self)
//        }
//        self.backendService.enqueue(request: request)
//    }
//
//    private func searchFinished(with result: Result<AlbumsResult, Error>) {
//        switch result {
//        case .success(let received):
//            self.totalElements = received.pagination.total
//            paging.nextPage()
//            self.albums.append(contentsOf: received.albums)
//            break
//        case .failure(let error):
//            print(error)
//            break
//        }
//        searching = false
//    }
//
//    func totalCount() -> Int {
//        guard totalElements > 0 else {
//            return AlbumsDataProvider.optimizedCount
//        }
//        return totalElements
//    }
//
//    func album(for index: Int) -> Album? {
//        guard index < albums.count else {
//            return .none
//        }
//        return albums[index]
//    }
//
//    func isLoading(for indexPath: IndexPath) -> Bool {
//        guard !self.albums.isEmpty else {
//            return false
//        }
//        return indexPath.row > self.albums.count
//    }
//}
