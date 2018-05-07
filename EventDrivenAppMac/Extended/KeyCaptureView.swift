//
//  QMWindow.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 2/24/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import Cocoa

protocol KeyCaptureViewDelegate {
    
    func keyCaptureView(_ view: KeyCaptureView, performKeyEquivalentWith event: NSEvent) -> Bool
}

class KeyCaptureView: NSView {
    
    public var delegate: KeyCaptureViewDelegate?
        
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        
        var result = false
        
        if let validDelegate = delegate {
            
            result = validDelegate.keyCaptureView(self, performKeyEquivalentWith: event)
        }

        guard result else {
            
            return super.performKeyEquivalent(with: event)
        }
        
        return true
    }
}
