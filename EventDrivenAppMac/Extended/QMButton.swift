//
//  QMButton.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 12/17/17.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Cocoa


@IBDesignable class QMButton: NSButton {
    
//    @IBInspectable var backgroundColor: NSColor?
    @IBInspectable var textColor: NSColor?
//    @IBInspectable var backgroundImage: NSImage?
//    @IBInspectable var borderColor: NSColor? = nil
//    @IBInspectable var borderWidth: CGFloat = 0
//    @IBInspectable var cornerRadius: CGFloat = 0
    
    override func awakeFromNib() {
   
        super.awakeFromNib()
        
       applyTextColor()
    }
    
    override var title: String {
        
        didSet{
            applyTextColor()
        }
    }
    
    // MARK: - life cycle -
    
    
    override func viewDidMoveToWindow() {
        
        super.viewDidMoveToWindow()
        /**
         this prevents nsbutton ass backwards behaviour
         when it changes it's state without changing the image to default/alternate and vise versa
         */
        let buttonCell = cell as? NSButtonCell
        buttonCell?.showsStateBy = .contentsCellMask
    }
    
    // MARK: - logic -
    
    private func applyTextColor() {
        
        guard let textColor = textColor, let font = font  else {
            return;
        }
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        let attributes =
            [
                NSAttributedStringKey.foregroundColor: textColor,
                NSAttributedStringKey.font: font,
                NSAttributedStringKey.paragraphStyle: style
                ] as [NSAttributedStringKey : Any]
        
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        self.attributedTitle = attributedTitle
    }
}
