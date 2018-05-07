//
//  MainWindow.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 12/9/17.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Cocoa

class MainWindowController : NSWindowController {//, NSWindowRestoration {
    
    // MARK: - Window Controller Lifecycle
    
    override func awakeFromNib() {

        if let screen = NSScreen.main {
            
            window?.setFrame(screen.visibleFrame, display: true, animate: true)
        }
    }
}

extension MainWindowController : NSWindowDelegate {
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        NSApplication.shared.terminate(self)
        return true
    }
}

