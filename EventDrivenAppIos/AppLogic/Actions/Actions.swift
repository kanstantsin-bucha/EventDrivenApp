//
//  Actions.swift
//  EventDrivenApp
//
//  Created by Kanstantsin Bucha on 8/6/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import ReactiveReSwift

//MARK: - interface action -

enum InterfaceStatelessAction {
    
    case initial
}

enum InterfaceAction: Action {

    case makeRed
    case makeGreen
}

//MARK: - user action -

enum UserAction: Action {

    case increaseCounter
    case decreaseCounter
}

//MARK: - business logic action -

enum DataAction: Action {
 
    case increase
    case decrease
}
