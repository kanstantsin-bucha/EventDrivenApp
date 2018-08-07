//
//  CrashlyticsIntegration.swift
//  TruebuchaTagMac
//
//  Created by Kanstantsin Bucha on 2/21/18.
//  Copyright © 2018 Truebucha LLC. All rights reserved.
//

import Foundation
import Fabric
import Crashlytics

class CrashlyticsIntegration: IntegrationSubitemInterface {
    
    func enable(infoDictionary: [String : Any]?,
                launchOptions: [AnyHashable : Any]?) {
    
        let defaults = ["NSApplicationCrashOnExceptions": true]
        UserDefaults.standard.register(defaults: defaults)
        
        Fabric.with([Crashlytics.self])
    }
}
