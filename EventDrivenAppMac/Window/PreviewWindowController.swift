//
//  PreviewWindowController.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 2/25/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import Cocoa


class PreviewWindowController: NSWindowController {
    
}

extension PreviewWindowController : NSWindowDelegate {
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        
        User.did(.preview(action: .close))
        return false
    }
}
