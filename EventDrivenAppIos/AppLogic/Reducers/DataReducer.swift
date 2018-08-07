//
//  DataReducer.swift
//  EventDrivenApp
//
//  Created by Kanstantsin Bucha on 8/7/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import ReactiveReSwift
import RealmSwift
import BuchaSwift


let dataReducer: Reducer<DataState> = { action, state in
    
    guard let dataAction = action as? DataAction else {
        
        print("[Error]: dataReducer failed to interpret not data action: \(action)")
        return state
    }
    
    ActionTracker.data(action: dataAction)
    
    print("==========================")
    print("received data action: \(dataAction)")
    
    let result: DataState
    
    switch dataAction {
        
    case .increase:
        
        result = DataState(state, counter: state.counter + 1)
        
    case .decrease:

        result = DataState(state, counter: state.counter - 1)
    }
    
    if (result.settings !== state.settings) {
        
        DataReducer.store(settings: result.settings)
    }
    
    print("got state: \(result)")
    print("==========================")
    
    return result
}

//MARK: - store -

class DataReducer {
    
    //MARK: Settings Load / Store Logic
    
    static func loadSettings() -> SettingsData {
        
        var settingsStorage: SettingsStorage? = nil
        
        let realm = try! Realm()
        settingsStorage = realm.objects(SettingsStorage.self).first
        
        guard let validStorage = settingsStorage else {
            
            return SettingsData(contactsLookupEnabled: false)
        }
        
        let result = SettingsData(using: validStorage)
        return result
    }

    static func store(settings: SettingsData) {
        
        let realm = try! Realm()
        
        let settingsStorage = realm.objects(SettingsStorage.self).first
        
        let validStorage = settingsStorage ?? SettingsStorage()
        
        try! realm.write {
            validStorage.update(using: settings)
            realm.add(validStorage)
        }
    }
}

