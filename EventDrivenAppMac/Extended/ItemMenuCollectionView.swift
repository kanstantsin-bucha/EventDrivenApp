//
//  QMCollectionView.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 2/24/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import Cocoa

protocol ItemMenuCollectionViewDelegate : NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView,
                        menu: NSMenu?,
                        at indexPath: IndexPath?) -> NSMenu?
}

class ItemMenuCollectionView: NSCollectionView {
    
    override func menu(for event: NSEvent) -> NSMenu? {
        
        let point = self.convert(event.locationInWindow, from: nil)
        
        let indexPath = self.indexPathForItem(at: point);
        
        var menu = super.menu(for: event);
        
        if let validDelegate = delegate as? ItemMenuCollectionViewDelegate {
            
            menu = validDelegate.collectionView(self, menu: menu, at: indexPath);
        }
        
        return menu;
    }
    
}
