//
//  GoogleAnalyticsIntegration.swift
//  TruebuchaTagMac
//
//  Created by Kanstantsin Bucha on 2/21/18.
//  Copyright © 2018 Truebucha LLC. All rights reserved.
//

import Foundation

class GoogleAnalyticsIntegration: IntegrationSubitemInterface {
    
    func enable(infoDictionary: [String : Any]?,
                launchOptions: [AnyHashable : Any]?) {
        
        let google = infoDictionary?["Google"] as? NSDictionary
        let identifier = google?["GA-TrackingID"] as? String
        
        guard let validIdentifier = identifier else {
            
            print("[Error]: Failed to read Google Analytics identifier from the info.plist file (Google->GA-TrackingID)")
            return
        }
        
        guard let gai = GAI.sharedInstance() else {
            
            print("[Error]: Google Analytics not configured correctly")
            return
        }
        
        gai.tracker(withTrackingId: validIdentifier)
        gai.trackUncaughtExceptions = true
        
        #if DEBUG
            gai.logger.logLevel = .verbose;
        #endif
    }
}
