//
//  ArtistTableViewCell.swift
//  Musically
//
//  Created by Martin on 9/27/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import UIKit

class ArtistTableViewCell: UITableViewCell, ReusableObject {
    private var viewTapBehaviour: ViewTapBehaviour!
    private var openUrlBehaviour: ViewOpenUrlBehaviour!
    
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var listeners: UILabel!
    @IBOutlet weak var identifier: UILabel!
    @IBOutlet weak var artistPhoto: MMImageView!
    @IBOutlet weak var loadingContainer: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.artistPhoto.layer.cornerRadius = 3.0
        self.artistPhoto.layer.masksToBounds = true
    }
    
    func setup(with viewModel: ArtistSearchCellViewModelProtocol) {
        name.text = viewModel.artistName()
        listeners.text = viewModel.artistListeners()
        identifier.text = viewModel.artistIdentifier()
        artistPhoto.image = UIImage.init(named: "PhotoPlaceholder")
        if viewModel.hasArtistPhotoURL() {
            artistPhoto.download(image: viewModel.artistPhotoURL())
            openUrlBehaviour = ViewOpenUrlBehaviour.init(views: [artistPhoto], url: viewModel.artistPhotoURL())
        }
        set(loading: viewModel.isLoading())
    }
    
    func set(onTap: @escaping (() -> Void)) {
        viewTapBehaviour = ViewTapBehaviour.init(views: [mainContainer], onTap: onTap)
    }
    
    private func set(loading: Bool) {
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
