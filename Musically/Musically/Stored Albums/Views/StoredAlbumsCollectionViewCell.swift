//
//  StoredAlbumsCollectionViewCell.swift
//  Musically
//
//  Created by Martin on 10/5/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import UIKit

class StoredAlbumsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var albumGraphics: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        albumGraphics.layer.cornerRadius = 3.0
        albumGraphics.layer.masksToBounds = true
        albumName.layer.backgroundColor = UIColor.blue.cgColor
    }
    
    func setup(with albumDetails: AlbumDetails) {
        let graphics = albumDetails.images.filter { (graphics) -> Bool in
            return graphics.size == GraphicsSize.extralarge
        }
        if let imageUrl: URL = graphics.first?.url {
            albumGraphics.download(image: imageUrl)
        }
        albumName.text = albumDetails.albumName
    }
    
    func startAnimations() {
        let animation = CABasicAnimation.init(keyPath: "backgroundColor")
        animation.fromValue = UIColor.blue.cgColor
        animation.toValue = UIColor.green.cgColor
        animation.duration = 4
        animation.repeatDuration = .infinity
        animation.autoreverses = true
        albumName.layer.add(animation, forKey: "backgroundColorAnimation")
    }
    
    func stopAnimations() {
        albumName.layer.removeAnimation(forKey: "backgroundColorAnimation")
    }
}
