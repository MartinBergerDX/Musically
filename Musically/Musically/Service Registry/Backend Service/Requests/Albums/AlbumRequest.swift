//
//  AlbumRequest.swift
//  Musically
//
//  Created by Martin on 10/2/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

struct AlbumRequest: BackendRequest, PagedBackendRequest {
    var method: String = HTTPMethod.get.description
    var completion: ((Result<AlbumsResult, Error>) -> Void)?
    var limit: Int = Pagination.defaultLimit
    var page: Int = Pagination.defaultPage
    var endpoint: String = "artist.gettopalbums"
    var arguments: String {
        get {
            var args: String = ""
            if !mbid.isEmpty {
                args.append("mbid=")
                args.append(mbid)
            } else if !artist.isEmpty {
                args.append("artist=")
                args.append(artist)
            }
            args.append(pagingArguments())
            return args
        }
    }
    var mbid: String = ""
    var artist: String = ""
    
    func onComplete(result: Result<Data,Error>) {
        switch result {
        case .success(let data):
            let decoder = JSONDecoder()
            do {
                let received = try decoder.decode(AlbumsResult.self, from: data)
                self.completion?(.success(received))
            } catch let error {
                self.completion?(.failure(error))
            }
            
        case .failure(let error):
            self.completion?(.failure(error))
        }
    }
}
