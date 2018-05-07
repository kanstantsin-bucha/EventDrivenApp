//
//  PanelFactory.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 1/10/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Cocoa

class PanelFactoy {
    
    static var storyboard: NSStoryboard {
        return NSStoryboard(name: NSStoryboard.Name("Panels"), bundle: nil)
    }
    
    static func identifier(for panel: Panel) -> String{
        
        switch panel {
        case .textEditor:
            return "\(Panel.textEditor)"
        default:
            return "\(panel)"
        }
    }
    
    static func skip() {
        
    }
    
    static func loadViewController(for panel: Panel) -> NSViewController {
        
        let id: String = identifier(for: panel)
        
        let sceneId = NSStoryboard.SceneIdentifier(id)
        let result = storyboard.instantiateController(withIdentifier: sceneId) as! NSViewController
        
        switch panel {
        
        case .textEditor:
            
            let editor = result as! TextEditorRepresentation
            var mutatingEditor = editor
            mutatingEditor.logic = TextEditor(textEditor: editor)
            
        default:
            skip()
        }

        return result
    }
}
