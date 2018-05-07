//
//  QMCollectionView.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 2/28/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import Cocoa

class QMCollectionView: ItemMenuCollectionView {
    
    override func keyDown(with event: NSEvent) {
        
        let modifiers: NSEvent.ModifierFlags = [.command, .control, .option]
        
        guard event.modifierFlags.intersection(modifiers).rawValue == 0 else {
            
            super.keyDown(with: event)
            return
        }
        
        guard event.charactersIgnoringModifiers == " " else {
            
            super.keyDown(with: event)
            return
        }
        
        self.nextResponder?.keyDown(with: event)
    }
}
