//
//  QMTextView.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 2/9/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import Cocoa

class QMTextView: NSTextView {

    
    @IBInspectable var fontSize: CGFloat = 24
    @IBInspectable var fontColor: NSColor? = nil
    @IBInspectable var borderColor: NSColor? = nil
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var cornerRadius: CGFloat = 0
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        textColor = fontColor
        font = NSFont.systemFont(ofSize: fontSize)
        
        guard let borderColor = borderColor  else {
            return;
        }
        
        wantsLayer = true
        layer?.borderColor = borderColor.cgColor
        layer?.borderWidth = borderWidth
        layer?.cornerRadius = cornerRadius
        
    }
    
}

