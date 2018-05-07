//
//  QMTableRowView.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 12/17/17.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Cocoa


@IBDesignable class QMTableRowView: NSTableRowView {
    
    @IBInspectable var selectedColor: NSColor = .blue
    @IBInspectable var rootColor: NSColor = .white
    @IBInspectable var nestedColor: NSColor = .white
    
    
    override func drawSelection(in dirtyRect: NSRect) {
        
        guard self.selectionHighlightStyle != .none else {
            return
        }
    
        //            NSColor(calibratedWhite: 0.65, alpha: 1).setStroke()
        //            NSColor(calibratedWhite: 0.82, alpha: 1).setFill()
        
        selectedColor.setStroke()
        selectedColor.setFill()
        
//        let selectionRect = NSInsetRect(self.bounds, 2.5, 2.5)

        let selectionPath = NSBezierPath(rect: dirtyRect)
        selectionPath.fill()
        selectionPath.stroke()
    
    }
}
