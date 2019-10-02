//
//  AlbumInfoRequest.swift
//  Musically
//
//  Created by Martin on 9/26/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

// https://www.last.fm/api/show/artist.search

struct ArtistSearchRequest: BackendRequest, PagedBackendRequest {
    var method: String = HTTPMethod.get.description
    var completion: ((Result<ArtistSearchResult, Error>) -> Void)?
    var limit: Int = Pagination.defaultLimit
    var page: Int = Pagination.defaultPage
    var endpoint: String = "artist.search"
    var arguments: String {
        get {
            return "artist=" + artist + pagingArguments()
        }
    }
    var artist: String = ""
    
    func onComplete(result: Result<Data,Error>) {
        switch result {
        case .success(let data):
            let decoder = JSONDecoder()
            do {
                let received = try decoder.decode(ArtistSearchResult.self, from: data)
                self.completion?(.success(received))
            } catch let error {
                self.completion?(.failure(error))
            }
            
        case .failure(let error):
            self.completion?(.failure(error))
        }
    }
}
