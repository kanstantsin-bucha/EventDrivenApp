//
//  GoogleGeocoderIntegration.swift
//  EventDrivenApp
//
//  Created by Kanstantsin Bucha on 8/6/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import QMGeocoder

class GoogleGeocoderIntegration: IntegrationSubitemInterface {
    
    func enable(infoDictionary: [String : Any]?,
                launchOptions: [AnyHashable : Any]?) {
        
        // we read a key from the info.plist file
        QMGeocoder.shared().acceptGoogleGeocoderApiKey("")
    }
}
