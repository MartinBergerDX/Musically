//
//  AlbumDetailsNoDataView.swift
//  Musically
//
//  Created by Martin on 10/7/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import UIKit

class AlbumDetailsNoDataView: UIView {
    @IBOutlet weak var noData: UILabel!
    
    func setup(with parentView: UIView, animator: UIDynamicAnimator) {
        installConstraints(parentView: parentView)
        addBehaviors(animator: animator)
    }
    
    func installConstraints(parentView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
        self.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
        NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: parentView, attribute: .width, multiplier: 0.8, constant: 0.0).isActive = true
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func addBehaviors(animator: UIDynamicAnimator) {
        let gravity = UIGravityBehavior.init(items: [self])
        animator.addBehavior(gravity)
        let collision = UICollisionBehavior.init(items: [self])
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        let elasticity = UIDynamicItemBehavior.init(items: [self])
        elasticity.elasticity = 0.9
        animator.addBehavior(elasticity)
    }
}
