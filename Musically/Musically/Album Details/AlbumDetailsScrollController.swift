//
//  AlbumScrollController.swift
//  Musically
//
//  Created by Martin on 10/3/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import UIKit

class AlbumDetailsScrollController: NSObject {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainContainer: UIStackView!
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
        name.text = details.albumName
        artist.text = details.artistName
        mbid.text = details.mbid
        
        let medium = details.images.filter { (graphics) -> Bool in
            return graphics.size == GraphicsSize.large
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
            content.text = details.content
        }
        
        for track in details.tracks {
            let nibName = String.init(describing: TrackView.self)
            let trackView: TrackView = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as! TrackView
            trackView.setup(with: track)
            tracks.addArrangedSubview(trackView)
        }
    }
    
    private var animator: UIDynamicAnimator!
    func noData() {
        
        let parentView: UIView = scrollView.superview!
        scrollView.removeFromSuperview()
        let nibName = String.init(describing: AlbumDetailsNoDataView.self)
        let noDataView: AlbumDetailsNoDataView = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as! AlbumDetailsNoDataView
        parentView.addSubview(noDataView)
        animator = UIDynamicAnimator.init(referenceView: parentView)
        noDataView.setup(with: parentView, animator: animator)
    }
}
