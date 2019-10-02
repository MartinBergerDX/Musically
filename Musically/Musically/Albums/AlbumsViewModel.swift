//
//  AlbumsViewModel.swift
//  Musically
//
//  Created by Martin on 10/2/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

protocol AlbumsViewModelOutput: class {
    func updated(viewModel: AlbumsViewModel)
}

class AlbumsViewModel: NSObject {
    private static let optimizedCount = 100 // needed because server can return large data sets
    weak var output: AlbumsViewModelOutput!
    private var albums: [Album] = []
    private var searching = false // mutated on main thread only
    private var page: Int = Pagination.defaultPage
    private var totalElements: Int = 100
    var backendService: BackendServiceProtocol!
    var artist: Artist!
    
    override init() {
        super.init()
    }
    
    func search() {
        guard !searching else {
            return
        }
        searching = true
        
        var request = AlbumRequest.init()
        request.page = page
        request.artist = artist.name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        request.mbid = artist.mbid.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        request.completion = { [unowned self] (result) in
            self.searchFinished(with: result)
            self.output.updated(viewModel: self)
        }
        self.backendService.execute(request: request)
    }
    
    private func searchFinished(with result: Result<AlbumsResult, Error>) {
        switch result {
        case .success(let received):
            self.totalElements = received.pagination.total
            self.page += 1
            self.albums.append(contentsOf: received.albums)
            break
        case .failure(let error):
            print(error)
            break
        }
        searching = false
    }
    
    func totalCount() -> Int {
        guard totalElements > 0 else {
            return AlbumsViewModel.optimizedCount
        }
        return totalElements
    }
    
    func album(for index: Int) -> Album? {
        guard index < albums.count else {
            return .none
        }
        return albums[index]
    }
    
    func isLoading(for indexPath: IndexPath) -> Bool {
        guard !self.albums.isEmpty else {
            return false
        }
        return indexPath.row > self.albums.count
    }
}
