//
//  InterfaceState.swift
//  EventDrivenApp
//
//  Created by Kanstantsin Bucha on 8/7/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation

struct InterfaceState {
    
    let viewControllerBackground: UIColor
    
    init(viewControllerBackground: UIColor) {
        
        self.viewControllerBackground = viewControllerBackground
    }
    
    init(_ precedent: InterfaceState,
         viewControllerBackground: UIColor? = nil) {
        
        self.viewControllerBackground = viewControllerBackground ?? precedent.viewControllerBackground
    }

}
