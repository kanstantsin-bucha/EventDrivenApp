//
//  QMTextField.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 1/8/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Cocoa

class QMTextField: NSTextField {
    
    @IBInspectable var borderColor: NSColor? = nil
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var cornerRadius: CGFloat = 0
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        guard let borderColor = borderColor  else {
            return;
        }
        
        wantsLayer = true
        layer?.borderColor = borderColor.cgColor
        layer?.borderWidth = borderWidth
        layer?.cornerRadius = cornerRadius
        
    }
    
}
