//
//  File.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 2/23/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import RealmSwift

class SettingsStorage: Object {
    
    var availableTypes: [ImageType]  {
        
        let result = SettingsStorage.types(using: typesData)
        return result
    }
    

    @objc dynamic var typesData: Data = SettingsStorage.typesData(for: [])
    
    
    public func update(using data: SettingsData) {
        
        let typesData = SettingsStorage.typesData(for: data.imageFile.availableTypes)
        self.typesData = typesData
    }
    
    // MARK: - logic -
    
    static private func typesData(for types: [ImageType]) -> Data {
        
        let rawTypes = SettingsStorage.rawTypes(for: types)
        let result = NSKeyedArchiver.archivedData(withRootObject: rawTypes)
        return result
    }
    
    static private func types(using typesData: Data) -> [ImageType] {
        
        let unarchivedTypes: Any?
        
        do {
            
            unarchivedTypes = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(typesData)
        } catch let error {
            
            print("Failed to unarchive availableTypes from \(typesData) error: \(error)")
            return Settings.program.defaultImageTypes
        }
        
        guard let rawTypes = unarchivedTypes as? [Int] else {
            
            return Settings.program.defaultImageTypes
        }
        
        let result = types(for: rawTypes)
        
        return result
    }
    
    static private func rawTypes(for types: [ImageType]) -> [Int] {
        
        let result = types.map { $0.rawValue }
        return result
    }
    
    static private func types(for rawTypes: [Int]) -> [ImageType] {
        
        let result = rawTypes.map { ImageType(rawValue: $0)! }
        return result
    }
}
