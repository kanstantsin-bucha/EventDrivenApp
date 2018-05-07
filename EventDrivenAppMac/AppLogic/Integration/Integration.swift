//
//  Integration.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 1/10/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation

protocol IntegrationInterface {
    
    func enable()
}

protocol DevMateIntegrationInterface: IntegrationInterface {
    
    func showFeedbackDialog()
    
    //MARK: - indy -
    func checkForUpdates()
    func enableTrial() 
    func activate()
    
    //MARK: - debug -
    func showDebugMenu()
}


class Integration {
    
    let realm: IntegrationInterface = RealmIntegration()
    let analytics: IntegrationInterface = GoogleAnalyticsIntegration()
    let geocoder: IntegrationInterface = GoogleGeocoderIntegration()
    
    func enable() {
        
        realm.enable()
        analytics.enable()
        geocoder.enable()
    }
}



