//
//  QMTokenSourceField.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 2/19/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import Cocoa

class QMTokenSourceField: NSTokenField, QMTextSourceProtocol {
    
    @IBInspectable var savedColor: NSColor? = nil
    @IBInspectable var modifiedColor: NSColor? = nil
    
    //MARK: - life cycle -
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        applyObject([])
        
        tokenizingCharacterSet = CharacterSet(charactersIn: ",")
    }
    
    //MARK: - interface -
    
    public func applyObject(_ object: Any?,
                            source: DataSource = .file) {
        
        let sourceState : QMTextSourceState
        
        switch source {
            
        case .file:
            
            sourceState = .saved
            
        case .user:
            
            sourceState = .modified
            
        }
        
        applySource(sourceState)
        
        objectValue = object
    }
    
    public func applySource(_ source: QMTextSourceState) {
        
        switch source {
            
        case .saved:
            
            if let correctedFont = font?.unbold() {
                font = correctedFont
            }
            if let saved = savedColor {
                textColor = saved
            }
            tokenStyle = .plainSquared
            
        case .modified:
        
            if let correctedFont = font?.bold() {
                font = correctedFont
            }
            if let modified = modifiedColor {
                textColor = modified
            }
            tokenStyle = .squared
            
        case .invalid:
            
            if let correctedFont = font?.bold() {
                font = correctedFont
            }
            if let modified = modifiedColor {
                textColor = modified
            }
            tokenStyle = .plainSquared
            
        }
    }
    
    //MARK: - logic -
    
    override func textDidChange(_ notification: Notification) {
        
        super.textDidChange(notification)
        
        applySource(.modified)
    }
}
