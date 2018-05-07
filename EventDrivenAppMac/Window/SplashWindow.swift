//
//  SplashWindow.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 4/17/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import Cocoa

class SplashWindow : NSWindow {
    
    override init(contentRect: NSRect,
                  styleMask style: NSWindow.StyleMask,
                  backing backingStoreType: NSWindow.BackingStoreType,
                  defer flag: Bool) {
        
        super.init(contentRect: contentRect,
                   styleMask: NSWindow.StyleMask.borderless,
                   backing: NSWindow.BackingStoreType.nonretained,
                   defer: false)
        
        self.appearance = NSAppearance(appearanceNamed: .vibrantDark,
                                       bundle: nil)
        self.styleMask = style.union(.borderless)
        self.titleVisibility = NSWindow.TitleVisibility.hidden
        self.titlebarAppearsTransparent = true
        self.isMovableByWindowBackground = true
        self.level = NSWindow.Level.modalPanel
        self.alphaValue = 1;
        self.backgroundColor = .black;
        self.hasShadow = true;
    }
}
