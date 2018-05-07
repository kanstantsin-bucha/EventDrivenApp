//
//  FolderBarState.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 12/21/17.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation


struct FolderbarState {
    
    let enabled: Bool
    let items: [FolderItem]

//    init(enabled: Bool, items: [FolderItem]) {
//
//        self.enabled = enabled
//        self.items = items
//
//    }
    
}

extension FolderbarState: CustomStringConvertible {
    
    var description: String {
        
        let folderbarText = self.enabled ? "enabled with \(items)"
                                         : "disabled"
        let result = "<\(String(describing: type(of: self))): folderbar \(folderbarText)>"
        return result
        
    }
    
}
