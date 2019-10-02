//
//  ViewOpenUrlBehaviour.swift
//  Musically
//
//  Created by Martin on 10/2/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import UIKit
import SafariServices

class ViewOpenUrlBehaviour {
    private var url: URL!
    private var mapped: [UIView:UIGestureRecognizer] = [:]
    init(views: [UIView], url: URL) {
        self.url = url
        for view in views {
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(onTap(view:)))
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(tap)
            mapped.updateValue(tap, forKey: view)
        }
    }
    
    @objc private func onTap(view: UIView) {
        if let root = ViewOpenUrlBehaviour.root {
            let browser = SFSafariViewController.init(url: url)
            root.present(browser, animated: true, completion: nil)
        }
    }
    
    deinit {
        for (view, tap) in mapped {
            view.removeGestureRecognizer(tap)
        }
    }
}

extension ViewOpenUrlBehaviour {
    static weak var root: UIViewController?
    static func set(root: UIViewController) {
        ViewOpenUrlBehaviour.root = root
    }
}
