//
//  GoogleGeocoderIntegration.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 4/5/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import QMGeocoder



class GoogleGeocoderIntegration: IntegrationInterface {
    
    func enable() {
//        we read a key from the info.plist file
        QMGeocoder.shared().acceptGoogleGeocoderApiKey("")
    }
}
