//
//  ArtistTableViewCell.swift
//  Musically
//
//  Created by Martin on 9/27/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import UIKit

class ArtistTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var listeners: UILabel!
    @IBOutlet weak var artistWebpage: UITextView!
    @IBOutlet weak var artistPhoto: UIImageView!
    private var textViewUrlOpener: TextViewUrlOpener!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.artistPhoto.layer.cornerRadius = 3.0
        self.artistPhoto.layer.masksToBounds = true
    }
    
    func setup(with artist: Artist) {
        self.name.text = artist.name
        self.listeners.text = "Listeners: " + artist.listeners;
        self.artistWebpage.text = artist.url.absoluteString
        if let imageUrl: URL = artist.image.first?.url {
            self.artistPhoto.download(image: imageUrl)
        }
        self.textViewUrlOpener = TextViewUrlOpener.init(acceptUrl: artist.url, textView: self.artistWebpage)
    }
}
