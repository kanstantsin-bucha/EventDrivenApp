//
//  EventTracker.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 2/21/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import GoogleAnalyticsTracker

class Event {
    
    //MARK: - iterface -
    
    static func user(action: UserAction) {
        
        let actions = readableActions(from: "\(action)")
    
        MPGoogleAnalyticsTracker.trackEvent(ofCategory: actions[safe: 0] ?? "",
                                            action: actions[safe: 1] ?? "",
                                            label: actions[safe: 2] ?? "",
                                            value: NSNumber(value: 0))
    }
    
    static func interface(action: InterfaceAction) {
        
        let actions = readableActions(from: "\(action)")
        
        let number = Float(actions[safe: 2] ?? "")
        
        MPGoogleAnalyticsTracker.trackEvent(ofCategory: "<Interface>",
                                            action: actions[safe: 0] ?? "",
                                            label: actions[safe: 1] ?? "",
                                            value: NSNumber(value: number ?? 0))
    }
    
    static func data(action: DataAction) {
        
        let actions = readableActions(from: "\(action)")
        
        MPGoogleAnalyticsTracker.trackEvent(ofCategory: "<Data>",
                                            action: actions[safe: 0] ?? "",
                                            label: actions[safe: 1] ?? "",
                                            value: NSNumber(value: 0))
    }
    
    //MARK: - logic -
    
    static private func readableActions(from action: String) -> [String] {
        
        let actionDesc = "\(action)"
        
        let actions = actionDesc.split(separator: "(").map{String($0)}
        
        var result: [String] = []
        
        for action in actions {
            let subactions = action.split(separator: ".").map{ String($0) }
            let clearAction = subactions.last?.replacingOccurrences(of: ")", with: "")
            guard let validAction = clearAction else {
                continue
            }
            result.append(validAction)
        }
        
        print(result)
        return result
    }

}
