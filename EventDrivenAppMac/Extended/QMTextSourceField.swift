//
//  QMTextSourceField.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 2/18/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import Cocoa

enum DataSource {
    
    case file, user
}

enum QMTextSourceState {
    
    case saved, modified, invalid
}

protocol QMTextSourceProtocol {

    func applySource(_ source: QMTextSourceState)
}

class QMTextSourceField: QMTextField, QMTextSourceProtocol {
    
    @IBInspectable var savedColor: NSColor? = nil
    @IBInspectable var modifiedColor: NSColor? = nil
    @IBInspectable var invalidColor: NSColor? = nil
    
    //MARK: - life cycle -
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        applyString("")
    }
    
    //MARK: - interface -
    
    public func applyString(_ string: String?,
                            source: QMTextSourceState = .saved) {
        
        applySource(source)
        
        stringValue = string ?? ""
    }
    
    public func applySource(_ source: QMTextSourceState) {
        
        switch source {
            
        case .saved:
            
            if let saved = savedColor {
                textColor = saved
            }
            if let correctedFont = font?.unbold() {
                font = correctedFont
            }
            
        case .modified:
            
            if let modified = modifiedColor {
                textColor = modified
            }
            if let correctedFont = font?.bold() {
                font = correctedFont
            }
            
        case .invalid:
            
            if let invalid = invalidColor {
                textColor = invalid
            }
            
            if let correctedFont = font?.bold() {
                font = correctedFont
            }
        }
    }
    
    //MARK: - logic -
    
//    override func textDidChange(_ notification: Notification) {
//        
//        super.textDidChange(notification)
//    }
}

extension QMTextSourceField {
    
    public func applyDataString(_ string: String?,
                                dataSource: DataSource = .file) {
        
        let sourceState : QMTextSourceState
        
        switch dataSource {
            
        case .file:
            
            sourceState = .saved
            
        case .user:
            
            sourceState = .modified
            
        }
    
        applyString(string, source: sourceState)
    }
    
}


