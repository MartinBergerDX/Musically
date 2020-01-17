//
//  ArtistTableViewCell.swift
//  Musically
//
//  Created by Martin on 9/27/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import UIKit

class ArtistTableViewCell: UITableViewCell, ReusableObject {
    var viewTapBehaviour: ViewTapBehaviour!
    private var openUrlBehaviour: ViewOpenUrlBehaviour!
    
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var listeners: UILabel!
    @IBOutlet weak var identifier: UILabel!
    @IBOutlet weak var artistPhoto: UIImageView!
    @IBOutlet weak var loadingContainer: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.artistPhoto.layer.cornerRadius = 3.0
        self.artistPhoto.layer.masksToBounds = true
    }
    
    func setup(with artist: Artist?) {
        name.text = ""
        listeners.text = "Listeners: ?"
        identifier.text = ""
        artistPhoto.image = UIImage.init(named: "PhotoPlaceholder")
        openUrlBehaviour = nil
        
        switch artist {
        case .some(let artist):
                name.text = artist.name
                listeners.text = "Listeners: " + artist.listeners;
                identifier.text = artist.mbid
                identifier.isHidden = artist.mbid.isEmpty ? true : false
                let medium = artist.image.filter { (graphics) -> Bool in
                    return graphics.size == GraphicsSize.medium
                }
                if let imageUrl: URL = medium.first?.url {
                    artistPhoto.download(image: imageUrl)
                }
                if let url: URL = artist.url {
                    openUrlBehaviour = ViewOpenUrlBehaviour.init(views: [artistPhoto], url: url)
                }
                set(loading: false)
            break
        case .none:
            set(loading: true)
            break
        }
    }
    
    func set(loading: Bool) {
        loadingContainer.isHidden = loading ? false : true
        loading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
        self.contentView.isUserInteractionEnabled = !loading
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewTapBehaviour = nil
        openUrlBehaviour = nil
    }
}
