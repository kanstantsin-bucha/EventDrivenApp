//
//  AppLogic.swift
//  EventDrivenApp
//
//  Created by Kanstantsin Bucha on 8/1/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation

import ReactiveReSwift
import RealmSwift


// MARK: Integrations

protocol IntegrationInterface {
    
    func enable(launchOptions: [AnyHashable : Any]?)
}

protocol IntegrationSubitemInterface {
    
    func enable(infoDictionary: [String : Any]?, launchOptions: [AnyHashable : Any]?)
}

let integration: IntegrationInterface = Integration()


// MARK: Stores
// The global application stores, which is responsible for managing the appliction state.

let dataStore = Store(reducer: dataReducer,
                      observable: ObservableProperty(DataState(counter: 0,
                                                               settings: SettingsData())))

let interfaceStore = Store(reducer: interfaceReducer,
                           observable: ObservableProperty(InterfaceState(viewControllerBackground: .gray)))


//MARK: Signals
// The solution for cases when you want to change a behaviour of
// some minor ui elements that are not described by interfaceStore data

let interfaceStatelessAction = ObservableProperty(InterfaceStatelessAction.initial)


//MARK: Application Business logic that responds to user actions

class User {
    
    static func did(_ action: UserAction) {
        
        ActionTracker.user(action: action)
        
        switch action {
            
        case .increaseCounter:
            
            dataStore.dispatch(DataAction.increase)
            interfaceStore.dispatch(InterfaceAction.makeGreen)
            
        case .decreaseCounter:

            dataStore.dispatch(DataAction.decrease)
            interfaceStore.dispatch(InterfaceAction.makeRed)
        }
    }
}

