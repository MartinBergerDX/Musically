//
//  UIImageView+Downloadable.swift
//  Musically
//
//  Created by Martin on 9/27/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func download(image fromUrl: URL) {
        let cache: NSCache = ServiceRegistry.shared.imageCache
        if let cachedImage: UIImage = cache.object(forKey: fromUrl.absoluteString as NSString) {
            self.image = cachedImage
            return
        }
        URLSession.shared.dataTask(with: fromUrl) { (data, response, error) in
            guard let imageData: Data = data else {
                return
            }
            guard let image: UIImage = UIImage.init(data: imageData) else {
                return
            }
            cache.setObject(image, forKey: fromUrl.absoluteString as NSString)
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
