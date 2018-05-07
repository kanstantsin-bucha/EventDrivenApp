//
//  QMFont.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 2/19/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import Cocoa

//https://stackoverflow.com/questions/39999093/swift-programmatically-make-uilabel-bold-without-changing-its-size/39999244

extension NSFont {
    
    func withTraits(_ traits: NSFontDescriptor.SymbolicTraits...) -> NSFont? {
        
        let appendingTraits = NSFontDescriptor.SymbolicTraits(traits)
        
        let traits = self.fontDescriptor.symbolicTraits
        let resultTraits = traits.union(appendingTraits)
        let descriptor = self.fontDescriptor.withSymbolicTraits(resultTraits)
        
        let result = NSFont(descriptor: descriptor, size: 0)
        return result
    }
    
    func withoutTraits(_ traits: NSFontDescriptor.SymbolicTraits...) -> NSFont? {
        
        let removingTraits = NSFontDescriptor.SymbolicTraits(traits)
        
        let traits = self.fontDescriptor.symbolicTraits
        let resultTraits = traits.subtracting(removingTraits)
        let descriptor = self.fontDescriptor.withSymbolicTraits(resultTraits)
        
        let result = NSFont(descriptor: descriptor, size: 0)
        return result
    }
    
    func bold() -> NSFont? {
        
        return withTraits(.bold)
    }
    
    func unbold() -> NSFont? {
        
        return withoutTraits(.bold)
    }
}
