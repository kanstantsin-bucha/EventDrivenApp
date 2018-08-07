//
//  RealmIntegration.swift
//  TruebuchaTagMac
//
//  Created by Kanstantsin Bucha on 1/24/18.
//  Copyright © 2018 Truebucha LLC. All rights reserved.
//

import Foundation
import RealmSwift

class RealmIntegration: IntegrationSubitemInterface {
    
    func enable(infoDictionary: [String : Any]?,
                launchOptions: [AnyHashable : Any]?) {

        var config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })

        #if DEBUG
            config.deleteRealmIfMigrationNeeded = true
        #endif

        Realm.Configuration.defaultConfiguration = config

//        clearAll()
    }
    
    func clearAll() {
        
        let realm = try! Realm()
        try! realm.write {
            
            realm.deleteAll()
        }
    }
}
