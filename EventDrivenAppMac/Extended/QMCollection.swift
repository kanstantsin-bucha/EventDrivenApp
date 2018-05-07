//
//  Collection.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 2/21/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation

extension Collection {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        
        return indices.contains(index) ? self[index] : nil
    }
    
}
