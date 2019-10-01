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
    private var textViewUrlBehaviour: TextViewOpenUrlBehaviour!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.artistPhoto.layer.cornerRadius = 3.0
        self.artistPhoto.layer.masksToBounds = true
    }
    
    func setup(with artist: Artist?) {
        switch artist {
        case .some(let artist):
                self.name.text = artist.name
                self.listeners.text = "Listeners: " + artist.listeners;
                
                self.artistWebpage.text = ""
                self.textViewUrlBehaviour = nil
                if let website = artist.url {
                    self.artistWebpage.text = website.absoluteString
                    self.textViewUrlBehaviour = TextViewOpenUrlBehaviour.init(acceptUrl: website, textView: self.artistWebpage)
                }
                
                if let imageUrl: URL = artist.image.first?.url {
                    self.artistPhoto.download(image: imageUrl)
                }
                
            break
        case .none:
            self.name.text = ""
            self.listeners.text = "Listeners: ?"
            self.artistWebpage.text = "Loading data"
            self.artistPhoto.image = UIImage.init(named: "PhotoPlaceholder")
            self.textViewUrlBehaviour = nil
            break
        }
        
    }
}
