//
//  ArtistTableViewCell.swift
//  Musically
//
//  Created by Martin on 9/27/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell, ReusableObject {
    var viewTapBehaviour: ViewTapBehaviour!
    private var openUrlBehaviour: ViewOpenUrlBehaviour!
    
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var playcount: UILabel!
    @IBOutlet weak var identifier: UILabel!
    @IBOutlet weak var albumPhoto: MMImageView!
    @IBOutlet weak var loadingContainer: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        albumPhoto.layer.cornerRadius = 3.0
        albumPhoto.layer.masksToBounds = true
    }
    
    func setup(with viewModel: AlbumCellViewModelProtocol) {
        name.text = viewModel.name()
        playcount.text = viewModel.playcount()
        albumPhoto.image = UIImage.init(named: "PhotoPlaceholder")
        if viewModel.hasAlbumPhotoURL() {
            albumPhoto.download(image: viewModel.albumPhotoURL())
        }
        identifier.text = viewModel.albumIdentifier()
        identifier.isHidden = viewModel.albumIdentifier().isEmpty
        set(loading: false)
    }
    
//    func setup(with album: Album?) {
//        openUrlBehaviour = nil
//        name.text = "Loading"
//        playcount.text = "Playcount: 0"
//        albumPhoto.image = UIImage.init(named: "PhotoPlaceholder")
//        identifier.text = "id"
//
//        switch album {
//        case .some(let album):
//                name.text = album.name
//                playcount.text = "Played: " + String(album.playcount) + " times.";
//                let medium = album.images.filter { (graphics) -> Bool in
//                    return graphics.size == GraphicsSize.medium
//                }
//                if let imageUrl: URL = medium.first?.url {
//                    albumPhoto.download(image: imageUrl)
//                }
//                identifier.text = album.mbid
//                identifier.isHidden = album.mbid.isEmpty ? true : false
//                if let url: URL = album.url {
//                    openUrlBehaviour = ViewOpenUrlBehaviour.init(views: [albumPhoto], url: url)
//                }
//                set(loading: false)
//            break
//        case .none:
//            set(loading: true)
//            break
//        }
//    }
    
    func set(onTap: @escaping (() -> Void)) {
        viewTapBehaviour = ViewTapBehaviour.init(views: [mainContainer], onTap: onTap)
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
