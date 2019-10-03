//
//  AlbumScrollController.swift
//  Musically
//
//  Created by Martin on 10/3/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import UIKit

class AlbumDetailsScrollController: NSObject {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var mbid: UILabel!
    @IBOutlet weak var albumPhoto: UIImageView!
    @IBOutlet weak var listeners: UILabel!
    @IBOutlet weak var playcount: UILabel!
    @IBOutlet weak var tracks: UIStackView!
    @IBOutlet weak var published: UILabel!
    @IBOutlet weak var content: UILabel!
    
    func setup(with details: AlbumDetails!) {
        name.text = details.name
        artist.text = details.artist
        mbid.text = details.mbid
        
        let medium = details.images.filter { (graphics) -> Bool in
            return graphics.size == GraphicsSize.medium
        }
        if let imageUrl: URL = medium.first?.url {
            albumPhoto.download(image: imageUrl)
        }
        
        listeners.isHidden = true
        if !details.listeners.isEmpty {
            listeners.isHidden = false
            listeners.text = "Listeners: " + details.listeners
        }
        
        playcount.isHidden = true
        if !details.playcount.isEmpty {
            playcount.isHidden = false
            playcount.text = "Playcount: " + details.playcount
        }

        published.isHidden = true
        if !details.published.isEmpty {
            published.isHidden = false
            published.text = "Published: " + details.published
        }
        
        content.isHidden = true
        if !details.content.isEmpty {
            content.isHidden = false
            content.text = "Published: " + details.content
        }
        
        for track in details.tracks {
            let nibName = String.init(describing: TrackView.self)
            let trackView: TrackView = Bundle.main.loadNibNamed(nibName, owner: TrackView.self, options: nil)?.first as! TrackView
            trackView.setup(with: track)
            tracks.addArrangedSubview(trackView)
        }
    }
}
