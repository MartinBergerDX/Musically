//
//  ImageCache.swift
//  Musically
//
//  Created by Martin on 3/14/20.
//  Copyright © 2020 Turbo. All rights reserved.
//

import UIKit

protocol ImageCacheProtocol {
    func object(forKey key: String) -> UIImage?
    func setObject(image: UIImage, key: String)
}

class ImageCache: ImageCacheProtocol {
    private let cache: NSCache<NSString, UIImage>!
    
    init() {
        cache = NSCache<NSString, UIImage>.init()
    }
    
    func object(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func setObject(image: UIImage, key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
