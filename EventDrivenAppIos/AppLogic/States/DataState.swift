//
//  DataState.swift
//  EventDrivenApp
//
//  Created by Kanstantsin Bucha on 8/7/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation

struct DataState {
    
    let counter: Int
    let settings: SettingsData
    
    init(counter: Int,
         settings: SettingsData) {
     
        self.counter = counter
        self.settings = settings
    }
    
    init(_ precedent: DataState,
         counter: Int? = nil,
         settings: SettingsData? = nil) {
        
        self.counter = counter ?? precedent.counter
        self.settings = settings ?? precedent.settings
    }
    
}

// MARK: Data Classes

class SettingsData {
    
    let contactsLookupEnabled: Bool
    
    init(contactsLookupEnabled: Bool) {
        
        self.contactsLookupEnabled = contactsLookupEnabled
    }
    
     init(_ precedent: SettingsData,
          contactsLookupEnabled: Bool? = nil) {
        
        self.contactsLookupEnabled = contactsLookupEnabled ?? precedent.contactsLookupEnabled
    }
    
    init(using storage: SettingsStorage) {
        
        self.contactsLookupEnabled = storage.contactsLookupEnabled
    }
}

