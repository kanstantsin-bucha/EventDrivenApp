//
//  Settings.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 12/11/17.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Cocoa


class Settings {
    
    static let splashScreen = SplashScreen()
    static let gallery = GallerySettings()
    static let program = Program()
}

class SplashScreen {
    
    let size = CGSize(width: 900, height: 600)
    let duration: Double = 2
}

class Program {
    
    let userManualUrl = URL(string: "https://truebucha.io/support/")!
    let tutorialUrl = URL(string: "https://www.youtube.com/channel/")!
    let settingsFolder = Program.supportDirectory.appendingPathComponent("\(Program.name)/Settings/")
    let backupFolder: URL = Program.documents.appendingPathComponent("\(Program.name)/Backups/")
    let defaultImageTypes: [ImageType] = [.dng, .tif, .png, .jpg]
    
    static var name: String {
        
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
    }
    
    static var version: String {
        
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    static var documents: URL {
        
        return FileManager.default.urls(for: .documentDirectory,
                                        in: .userDomainMask).first!
    }
    
    static var supportDirectory: URL {
        
        return FileManager.default.urls(for: .applicationSupportDirectory,
                                        in: .userDomainMask).first!
    }
    
}

class GallerySettings {
    
    let minGridItemSize = 100
    let maxGridItemSize = 200
    let defaultGridItemSize = 150
    let thumbnailDimension = Int(200 * NSScreen.main!.backingScaleFactor)
}



