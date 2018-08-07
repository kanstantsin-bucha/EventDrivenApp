//
//  ParseIntegartion.swift
//  EventDrivenApp
//
//  Created by Kanstantsin Bucha on 8/1/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import Parse

class ParseIntegration: IntegrationSubitemInterface {
    
    func enable(infoDictionary: [String : Any]?,
                launchOptions: [AnyHashable : Any]?) {
        
        let parse = infoDictionary?["Parse"] as? NSDictionary
        let parseAppId = parse?["AppId"] as? String
        let parseClientKey = parse?["ClientKey"] as? String
        let parseServer = parse?["ServerUrl"] as? String
        
        guard let appId = parseAppId,
              let clientKey = parseClientKey,
              let server = parseServer else {
            
            print("[Error]: Parse failed to get a config from a bundle info dictionary")
            return
        }
        
        let configuration = ParseClientConfiguration { (configuration) in
            
            configuration.applicationId = appId
            configuration.clientKey = clientKey
            configuration.server = server
            configuration.isLocalDatastoreEnabled = true
        }
        
        Parse.initialize(with: configuration)
        PFAnalytics.trackAppOpened(launchOptions: launchOptions)
    }
}
