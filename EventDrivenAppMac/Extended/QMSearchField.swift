//
//  QMSearchField.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 2/12/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import BuchaSwift


class QMSearchField<Element: AnyObject>: NSSearchField {
    
    private var searchText: String? = nil
    
    var didSelectResultBlock: DataCompletion<Element?>?
    var getResultTitleBlock: ((_ data: Element) -> (String))?
    
    // MARK: - interface -
    
    
    public func clearField() {
        
        stringValue = ""
        searchText = nil
    }
    
    public func displaySearchResults(_ results: [Element]) {
        
        guard results.count > 1 else {
            searchMenuTemplate = nil
            return
        }
        
        let menu = NSMenu()
        
        for result in results {
            
            let title: String
            if let validBlock = getResultTitleBlock {
                
                title = validBlock(result)
            } else {
                
                title = "undefined"
            }
            
            let item = NSMenuItem()
            
            item.title = title
            item.target = self
            item.action = #selector(QMSearchField.didSelectMenuItem(_:))
            item.representedObject = result
            item.tag = NSSearchField.recentsTitleMenuItemTag
            
            menu.addItem(item)
        }
        
        searchMenuTemplate = menu
    }
    
    //MARK: - logic -
    
    @objc private func didSelectMenuItem(_ sender: NSMenuItem) {
        
        guard let block = didSelectResultBlock else {
            return
        }
        
        block(sender.representedObject as? Element)
    }
    
    override func sendAction(_ action: Selector?, to target: Any?) -> Bool {
        
        let searchString = stringValue
        
        if action == "didEndEditingSearchField:"
              && searchString == searchText {
            
            return false
        }
        
        searchText = searchString
        
        let result = super.sendAction(action, to: target)
        return result
    }
}
