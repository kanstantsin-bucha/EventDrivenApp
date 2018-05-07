//
//  InterfaceState.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 1/29/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import Cocoa


enum Panel {
    
    case none
    case folders, settings, gallery
    case textEditor // needs TextEditorDataSource
}

enum Thickness {
    
    case flexible
    case points(value: Float)
    case fraction(value: Float)
}

class ThicknessContainer {
    
    let left: Thickness
    let center: Thickness
    let centerTop: Thickness
    let centerBottom: Thickness
    let right: Thickness
    
    init(left: Thickness = .flexible,
         center: Thickness = .flexible,
         centerTop: Thickness = .flexible,
         centerBottom: Thickness = .flexible,
         right: Thickness = .flexible) {
        
        self.left = left
        self.center = center
        self.centerTop = centerTop
        self.centerBottom = centerBottom
        self.right = right
    }
}

class PanelsState {
    
    let left: Panel
    let centerTop: Panel
    let centerBottom: Panel
    let right: Panel
    
    let thickness: ThicknessContainer
    
    
    init(left: Panel,
         centerTop: Panel,
         centerBottom: Panel,
         right: Panel,
         thickness: ThicknessContainer = ThicknessContainer()) {
    
        self.left = left
        self.centerTop = centerTop
        self.centerBottom = centerBottom
        self.right = right
        
        self.thickness = thickness
    }
}

enum UIScene {
    
    case gallery, settings
}

struct UIState {
    
    let activeScene: UIScene
    let sidebarHidden: Bool
}

class WindowInterface {
    
    let activeScene: UIScene
    let sidebarHidden: Bool
    var panels: PanelsState {
        return InterfaceReducer.panels(for: activeScene)
    }
    
    init (scene: UIScene = .gallery,
          sidebarHidden: Bool = false) {
        activeScene = scene
        self.sidebarHidden = sidebarHidden
    }
}

class FoldersInterface {
    
    let folded: Bool = false
}

class GalleryInterface {
    
    let gridItemSize: Int
    
    init(gridItemSize: Int = Settings.gallery.defaultGridItemSize) {
        
        self.gridItemSize = gridItemSize
    }
}

struct InterfaceState {
    
    let currentController: NSWindowController
    let mainWindow: WindowInterface
    let folders: FoldersInterface
    let gallery: GalleryInterface
    
    init(currentController: NSWindowController,
         mainWindow: WindowInterface,
         folders: FoldersInterface,
         gallery: GalleryInterface) {
        
        self.currentController = currentController
        self.mainWindow = mainWindow
        self.folders = folders
        self.gallery = gallery
    }

    init(_ precedent: InterfaceState,
         currentController: NSWindowController? = nil,
         mainWindow: WindowInterface? = nil,
         folders: FoldersInterface? = nil,
         gallery: GalleryInterface? = nil) {
        
        self.currentController = currentController ?? precedent.currentController
        self.mainWindow = mainWindow ?? precedent.mainWindow
        self.folders = folders ?? precedent.folders
        self.gallery = gallery ?? precedent.gallery
    }
}


    //MARK: - custom string convertible -

extension UIState: CustomStringConvertible {
    
    var description: String {
        
        let sidebarDesc = sidebarHidden ? "sidebar hidden" : "sidebar shown"
        let result = "<\(String(describing: type(of: self))): \(activeScene) \(sidebarDesc)>"
        return result
    }
}

extension PanelsState: CustomStringConvertible {
    
    var description: String {
        
        let result = "<\(String(describing: type(of: self))): left: \(left), centerTop: \(centerTop), centerBottom: \(centerBottom), right: \(right)>"
        return result
    }
}
