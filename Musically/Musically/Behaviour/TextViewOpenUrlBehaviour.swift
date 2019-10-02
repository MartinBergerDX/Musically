//
//  TextViewUrlHandlingDelegate.swift
//  Musically
//
//  Created by Martin on 9/27/19.
//  Copyright © 2019 Turbo. All rights reserved.
//

import Foundation
import UIKit

class TextViewOpenUrlBehaviour: NSObject, UITextViewDelegate {
    private var acceptUrl: URL!
    init(acceptUrl: URL, textView: UITextView) {
        super.init()
        self.acceptUrl = acceptUrl
        textView.delegate = self
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return URL == acceptUrl
    }
}
