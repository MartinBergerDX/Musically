//
//  MMImageView.swift
//  Musically
//
//  Created by Martin on 9/27/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation
import UIKit

class MMImageView: UIImageView {
    func download(image fromUrl: URL) {
        let cache: ImageCacheProtocol = imageCache()
        if let cachedImage: UIImage = cache.object(forKey: fromUrl.absoluteString) {
            self.image = cachedImage
            return
        }
        urlSession().dataTask(with: fromUrl) { (data, response, error) in
            guard let imageData: Data = data else {
                return
            }
            guard let image = UIImage.init(data: imageData) else {
                return
            }
            cache.setObject(image: image, key: fromUrl.absoluteString)
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
    
    func imageCache() -> ImageCacheProtocol {
        return ServiceRegistry.shared.imageCache
    }
    
    func urlSession() -> URLSession {
        return URLSession.shared
    }
}
