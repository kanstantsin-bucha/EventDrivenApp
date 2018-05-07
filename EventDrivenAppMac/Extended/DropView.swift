//
//  DropView.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 12/19/17.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Cocoa


protocol DropViewDelegate {
    
    func isAvailable(fileURL: URL) -> Bool
    func didReceiveDrop(ofFileURL fileURL: URL)
    
}


class DropView: NSView {
    
    var fileURL: URL?
    var delegate: DropViewDelegate?
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        if #available(OSX 10.13, *) {
             registerForDraggedTypes([NSPasteboard.PasteboardType.URL, NSPasteboard.PasteboardType.fileURL])
        }
    }
    
    override func draggingEntered(_ drag: NSDraggingInfo) -> NSDragOperation {
        
        let type = NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")
        guard let board = drag.draggingPasteboard().propertyList(forType: type) as? NSArray,
              let path = board[0] as? String else {
            return NSDragOperation()
        }
        
        let fileURL = URL(fileURLWithPath: path)
        
        if delegate?.isAvailable(fileURL: fileURL) == true {
            return .link
        } else {
            return NSDragOperation()
        }
        
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        
        let type = NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")
        guard let board = sender.draggingPasteboard().propertyList(forType: type) as? NSArray,
            let path = board[0] as? String else {
                return false
        }
        
        let fileURL = URL(fileURLWithPath: path)
        
        DispatchQueue.main.async { [weak self] in
            self?.fileURL = fileURL
            self?.delegate?.didReceiveDrop(ofFileURL: fileURL)
        }
        
        return true
        
    }
    
}
