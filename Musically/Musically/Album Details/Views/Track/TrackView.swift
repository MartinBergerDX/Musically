//
//  TrackView.swift
//  Musically
//
//  Created by Martin on 10/3/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import UIKit

class TrackView: UIView {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    func setup(with track: Track) {
        name.text = track.name
        
        let interval: Int = Int(track.duration) ?? 0
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .full
        
        let formattedString = formatter.string(from: TimeInterval(interval))!
        duration.text = formattedString
    }
}
