//
//  QMOutlineView.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 12/17/17.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Cocoa

protocol QMOutlineViewDelegate: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, canShowMenuFor item: Any?) -> Bool
}

@IBDesignable class QMOutlineView: NSOutlineView {
    
    @IBInspectable var disclosureOpenedImage: NSImage?
    @IBInspectable var disclosureClosedImage: NSImage?
    
    @IBInspectable var disclosureWidthCorrection: CGFloat = 5.0
    @IBInspectable var cellsLeadingSpace: CGFloat = 16.0

    override func makeView(withIdentifier identifier: NSUserInterfaceItemIdentifier, owner: Any?) -> NSView? {
        
        let result = super.makeView(withIdentifier: identifier, owner: owner)
        
        guard identifier == NSOutlineView.disclosureButtonIdentifier else {
            return result
        }
        
        if let button = result as? NSButton {
            button.image = disclosureClosedImage
            button.alternateImage = disclosureOpenedImage
        }
        
        return result
    }
    
    override func frameOfOutlineCell(atRow row: Int) -> NSRect {
        
        var result = super.frameOfOutlineCell(atRow: row)
        
        result.size.width += disclosureWidthCorrection
        
        return result
        
    }
    
    override func frameOfCell(atColumn column: Int, row: Int) -> NSRect {
        
        var result = super.frameOfCell(atColumn: column, row: row)
        
        result.origin.x += disclosureWidthCorrection + cellsLeadingSpace
        
        return result
    }
    
    override func menu(for event: NSEvent) -> NSMenu? {
        
        //The event has the mouse location in window space; convert it to our (the outline view's) space so we can find which row the user clicked on.
        let clickedPoint = convert(event.locationInWindow, from: nil)
        let clickedRow = row(at: clickedPoint)
        
        let rowLevel = level(forRow: clickedRow)
        
        //If the user did not click on a row, or is not exactly top level of hierarchy, return nil—that is, no menu.
        
        guard clickedRow != -1, rowLevel == 0 else {
            return nil;
        }
        
        guard let validDelegate = delegate as? QMOutlineViewDelegate else {
            
            return nil
        }
        
        let represented = item(atRow: clickedRow)
        let canShowMenu = validDelegate.outlineView(self, canShowMenuFor: represented)
        
        guard canShowMenu else {
            
            return nil
        }
        
        let result = super.menu(for: event)
        result?.items.first?.representedObject = represented
    
        return result
    }
}
