//
//  SplashWindowController.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 4/17/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import Cocoa


class SplashWindowController: NSWindowController {
    
    static func using(size windowSize: CGSize,
                      controller: NSViewController,
                      displayAt screen: NSScreen) -> SplashWindowController {
        
        let screenRect = screen.visibleFrame
        let newOriginX = floor((screenRect.maxX - windowSize.width) / 2)
        let newOriginY = floor((screenRect.maxY - windowSize.height) / 2)
        let origin = NSPoint(x: newOriginX,
                             y: newOriginY)
        
        let rect = NSRect(origin: origin,
                          size: windowSize)
        
        let window = SplashWindow(contentRect: rect,
                                  styleMask: .borderless,
                                  backing: .nonretained,
                                  defer: false)
        
        window.contentViewController = controller
        
        let result = SplashWindowController(window: window)
        
        return result
    }
}
