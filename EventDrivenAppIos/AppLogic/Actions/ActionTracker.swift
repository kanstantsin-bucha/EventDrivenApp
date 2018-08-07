//
//  ActionTracker.swift
//  EventDrivenApp
//
//  Created by Kanstantsin Bucha on 8/6/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation

class ActionTracker {
    
    //MARK: - iterface -
    
    static func user(action: UserAction) {
        
        let actions = readableActions(from: "\(action)")
        
        trackEvent(category: actions[safe: 0] ?? "",
                   action: actions[safe: 1] ?? "",
                   label: actions[safe: 2] ?? "",
                   value: NSNumber(value: 0))
    }
    
    static func interface(action: InterfaceAction) {
        
        let actions = readableActions(from: "\(action)")
        
        let number = Float(actions[safe: 2] ?? "")
        
        trackEvent(category: "<Interface>",
                   action: actions[safe: 0] ?? "",
                   label: actions[safe: 1] ?? "",
                   value: NSNumber(value: number ?? 0))
    }
    
    static func data(action: DataAction) {
        
        let actions = readableActions(from: "\(action)")
        
        trackEvent(category: "<Data>",
                   action: actions[safe: 0] ?? "",
                   label: actions[safe: 1] ?? "",
                   value: NSNumber(value: 0))
    }
    
    //MARK: - logic -
    
    static private func trackEvent(category: String,
                                   action: String,
                                   label: String,
                                   value: NSNumber) {
        
        let tracker = GAI.sharedInstance().defaultTracker
        let dict = GAIDictionaryBuilder.createEvent(withCategory: category,
                                                    action: action,
                                                    label: label,
                                                    value: value).build()
        guard let validTracker = tracker else {
            
            print("[Error]: ActionTracker: failed to get valid tracker");
            return
        }
        
        guard let validDict = dict as? [AnyHashable : Any] else {
            print("""
                [Error]: ActionTracker:
                              category: \(category)
                              action: \(category)
                              label: \(category)
                              value: \(value)
                """);
            print("[Error]: ActionTracker: failed to create event dictionary");
            return
        }
        
        validTracker.send(validDict)
    }
    
    static private func readableActions(from action: String) -> [String] {
        
        let actionDesc = "\(action)"
        
        let actions = actionDesc.split(separator: "(").map{ String($0) }
        
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

extension Collection {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        
        return indices.contains(index) ? self[index] : nil
    }
    
}
