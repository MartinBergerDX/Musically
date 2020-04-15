//
//  ViewTapBehaviour.swift
//  Musically
//
//  Created by Martin on 10/2/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import UIKit

class ViewTapBehaviour {
    private var callback: (() -> Void)!
    private var mapped: [UIView:UIGestureRecognizer] = [:]
    
    init(views: [UIView], onTap: @escaping () -> Void) {
        callback = onTap
        for view in views {
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(onTap(view:)))
            view.addGestureRecognizer(tap)
            mapped.updateValue(tap, forKey: view)
        }
    }
    
    @objc private func onTap(view: UIView) {
        callback()
    }
    
    deinit {
        for (view, tap) in mapped {
            view.removeGestureRecognizer(tap)
        }
    }
}
