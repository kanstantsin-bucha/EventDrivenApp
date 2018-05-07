//
//  QMEditableView.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 4/18/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import Cocoa

class QMEditableView: NSView {
    
    var isEditable = true
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        
        guard isEditable else {
            
            return nil
        }
        
        return super.hitTest(point)
    }
    
}
