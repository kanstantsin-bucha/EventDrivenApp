//
//  SettingsStorage.swift
//  EventDrivenApp
//
//  Created by Kanstantsin Bucha on 8/7/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import RealmSwift

class SettingsStorage: Object {
    
    @objc dynamic var contactsLookupEnabled: Bool = false
    
    public func update(using data: SettingsData) {
        
        self.contactsLookupEnabled = data.contactsLookupEnabled
    }
    
    // MARK: - logic -
    
//    static private func typesData(for types: [SomeType]) -> Data {
//
//        let rawTypes = SettingsStorage.rawTypes(for: types)
//        let result = NSKeyedArchiver.archivedData(withRootObject: rawTypes)
//        return result
//    }
//
//    static private func types(using typesData: Data) -> [SomeType] {
//
//        let unarchivedTypes: Any?
//
//        do {
//
//            unarchivedTypes = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(typesData)
//        } catch let error {
//
//            print("Failed to unarchive availableTypes from \(typesData) error: \(error)")
//            return Settings.program.defaultSomeTypes
//        }
//
//        guard let rawTypes = unarchivedTypes as? [Int] else {
//
//            return Settings.program.defaultSomeTypes
//        }
//
//        let result = types(for: rawTypes)
//
//        return result
//    }
//
//    static private func rawTypes(for types: [SomeType]) -> [Int] {
//
//        let result = types.map { $0.rawValue }
//        return result
//    }
//
//    static private func types(for rawTypes: [Int]) -> [SomeType] {
//
//        let result = rawTypes.map { SomeType(rawValue: $0)! }
//        return result
//    }
}
