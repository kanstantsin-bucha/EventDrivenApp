//
//  InterfaceReducer.swift
//  EventDrivenApp
//
//  Created by Kanstantsin Bucha on 8/7/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import ReactiveReSwift

let interfaceReducer: Reducer<InterfaceState> = { action, state in
    
    guard let interfaceAction = action as? InterfaceAction else {
        
        print("[Error]: interfaceReducer failed to interpret not interface action: \(action)")
        return state
    }
    
    ActionTracker.interface(action: interfaceAction)
    
    print("==========================")
    print("received interface action: \(interfaceAction)")
    
    let result: InterfaceState
    
    switch interfaceAction {
     
    case .makeGreen:
        
        result = InterfaceState(state, viewControllerBackground: .green)
        
    case .makeRed:
        
        result = InterfaceState(state, viewControllerBackground: .red)
    }

    print("got state: \(result)")
    print("==========================")
    
    return result
}

class InterfaceReducer {

}
