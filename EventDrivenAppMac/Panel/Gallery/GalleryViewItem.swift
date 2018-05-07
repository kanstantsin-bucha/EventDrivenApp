//
//  File.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 1/15/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Cocoa


class GalleryViewItem: NSCollectionViewItem {
    
    static let defaultOpacity: Float = 0.9
    
    static let nibNameString = String(describing: GalleryViewItem.self)
    static let reuseId = NSUserInterfaceItemIdentifier(nibNameString)
    static var nib: NSNib = {
        return NSNib(nibNamed: NSNib.Name(nibNameString), bundle: nil)!
    }()
    
    var indexPath: IndexPath? = nil
    
    func noteReuse(with incomingIndexPath: IndexPath) {
        
        if indexPath != incomingIndexPath {
            
            imageView?.image = nil
        }
        
        indexPath = incomingIndexPath
    }
        
    override var isSelected: Bool {
        didSet {
            if isSelected {
                view.layer?.borderWidth = 4.0
                view.layer?.opacity = 1
            } else {
                view.layer?.borderWidth = 0
                view.layer?.opacity = GalleryViewItem.defaultOpacity
                

            }
        }
    }
    
    override func awakeFromNib() {
        
        view.layer?.borderColor = NSColor (red: 0.16, green: 0.56, blue: 0.985, alpha: 1).cgColor
        view.layer?.opacity = GalleryViewItem.defaultOpacity
    }
}


