//
//  GoogleAnalyticsIntegration.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 2/21/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import GoogleAnalyticsTracker

class GoogleAnalyticsIntegration: IntegrationInterface {
    
    func enable() {
        
        let dictionary = Bundle.main.infoDictionary
        let google = dictionary?["Google"] as? NSDictionary
        let identifier = google?["GA-TrackingID"] as? String
        
        guard let validIdentifier = identifier else {
            
            print("Failed to read Google Analytics identifier from the info.plist file (Google->GA-TrackingID)")
            return
        }
        
        let configuration = MPAnalyticsConfiguration(analyticsIdentifier: validIdentifier)
        MPGoogleAnalyticsTracker.activate(configuration)
    }    
}
