//
//  integrations.swift
//  EventDrivenApp
//
//  Created by Kanstantsin Bucha on 8/1/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation

class Integration: IntegrationInterface {
    
    let realm: IntegrationSubitemInterface = RealmIntegration()
    let analytics: IntegrationSubitemInterface = GoogleAnalyticsIntegration()
    let crashlytics: IntegrationSubitemInterface = CrashlyticsIntegration()
    let parse: IntegrationSubitemInterface = ParseIntegration()
    let geocoder: IntegrationSubitemInterface = GoogleGeocoderIntegration()
    
    func enable(launchOptions: [AnyHashable : Any]?) {
        
        let info = Bundle.main.infoDictionary
        
        crashlytics.enable(infoDictionary: info, launchOptions: launchOptions)
        realm.enable(infoDictionary: info, launchOptions: launchOptions)
        analytics.enable(infoDictionary: info, launchOptions: launchOptions)
        parse.enable(infoDictionary: info, launchOptions: launchOptions)
        geocoder.enable(infoDictionary: info, launchOptions: launchOptions)
    }
}
