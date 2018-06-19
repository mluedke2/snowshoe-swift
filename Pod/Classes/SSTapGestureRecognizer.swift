//
//  SSTapGestureRecognizer.swift
//  StampSDK
//
//  Created by Jesse Stewart on 5/23/18.
//  Copyright © 2018 SnowShoe. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

class SSTapGestureRecognizer: UIGestureRecognizer {
    
    open var allTouches: Set<UITouch>?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        allTouches = event.allTouches
        if self.state == .possible {
            self.state = .recognized
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .failed
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .failed
    }
}
