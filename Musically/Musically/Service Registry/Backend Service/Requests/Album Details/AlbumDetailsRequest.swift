//
//  AlbumDetailsRequest.swift
//  Musically
//
//  Created by Martin on 10/2/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

struct AlbumDetailsRequest: BackendRequest {
    var method: String = HTTPMethod.get.description
    var completion: ((Result<AlbumDetails, Error>) -> Void)?
    var endpoint: String = "album.getinfo"
    var arguments: String {
        get {
            var args: String = ""
            if !mbid.isEmpty {
                args.append("mbid=")
                args.append(mbid)
            } else if !album.isEmpty {
                args.append("album=")
                args.append(album)
            }
            return args
        }
    }
    var mbid: String = ""
    var album: String = ""
    
    func onComplete(result: Result<Data,Error>) {
        switch result {
        case .success(let data):
            let decoder = JSONDecoder()
            do {
                let received = try decoder.decode(AlbumDetails.self, from: data)
                self.completion?(.success(received))
            } catch let error {
                self.completion?(.failure(error))
            }
            
        case .failure(let error):
            self.completion?(.failure(error))
        }
    }
}
