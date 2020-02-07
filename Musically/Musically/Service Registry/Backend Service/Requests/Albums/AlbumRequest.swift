//
//  AlbumRequest.swift
//  Musically
//
//  Created by Martin on 10/2/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation

class AlbumRequest: BackendRequest {
    var completion: ((Result<AlbumsResult, Error>) -> Void)?

//    var endpoint: String = "artist.gettopalbums"
//    var arguments: String {
//        get {
//            var args: String = ""
//            if !mbid.isEmpty {
//                args.append("mbid=")
//                args.append(mbid)
//            } else if !artist.isEmpty {
//                args.append("artist=")
//                args.append(artist)
//            }
//            args.append(pagingArguments())
//            return args
//        }
//    }
    var mbid: String = ""
    var artistName: String = ""

    init (artistName: String, mbid: String) {
        super.init()
        self.artistName = artistName
        self.mbid = mbid
        self.endpoint = "artist.search"
        self.arguments = (!mbid.isEmpty ? "mbid=" + mbid : "") + (!artistName.isEmpty ? "artist=" + artistName : "")
    }
    
    override func onComplete(result: Result<Data,Error>) {
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
