//
//  File.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 2/13/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import Cocoa

class AttachedWindow: NSWindow {
    
    init?(attachingView: NSView,
         controller: NSViewController? = nil,
         content: NSView? = nil,
         size: CGSize? = nil) {
        
        guard let attachingWindow = attachingView.window else {
            return nil
        }
        
        let attachingViewInWindowRect = attachingView.convert(attachingView.bounds, to: nil)
        let attachingViewInScreenRect = attachingWindow.convertToScreen(attachingViewInWindowRect)
        
        let contentView = controller != nil ? controller!.view
                                            : content
        
        let contentSize = size != nil ? size!
                                      : contentView?.bounds.size
        
        guard let validSize = contentSize else {
            return nil
        }
        
        var attachedRect = CGRect()
        attachedRect.size = validSize
        attachedRect.origin = CGPoint(x: attachingViewInScreenRect.origin.x,
                                      y: attachingViewInScreenRect.origin.y - validSize.height)
        
        super.init(contentRect: attachedRect, styleMask: .borderless, backing: .buffered, defer: true)
        
        self.contentViewController = controller
        self.contentView = contentView
        
        self.isOneShot = true
        
        attachingWindow.addChildWindow(self, ordered: .above)
    }
    
    func dissmiss() {
        
        self.parent?.removeChildWindow(self)
        self.orderOut(self)
    }
}
