 //
//  InterfaceReducer.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 1/10/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import ReactiveReSwift
import QuickLook
import Quartz

let interfaceReducer: Reducer<InterfaceState> = { action, state in
    
    guard let interfaceAction = action as? InterfaceAction else {
        return state
    }
    
    Event.interface(action: interfaceAction)
    
    print("==========================")
    print("received interface action: \(interfaceAction)")
    
    let result: InterfaceState
    
    switch interfaceAction {
        
    case .displaySplashScreen:
        
        guard let validScreen = NSScreen.main,
            let validViewController = InterfaceReducer.loadSplashScreenViewController() else {
            
            result = state
            break
        }
        
        let splashWindowController = SplashWindowController.using(size: Settings.splashScreen.size,
                                                                  controller: validViewController,
                                                                  displayAt: validScreen)
        
        InterfaceReducer.hideWindowOf(controller: state.currentController)
        InterfaceReducer.showWindowOf(controller: splashWindowController)
        
        result = InterfaceState(state,
                                currentController: splashWindowController)
        
    case .displayMainScreen:
        
        guard let mainWindowController = InterfaceReducer.loadMainWindowController() else {
            
            result = state
            break
        }
        
        InterfaceReducer.hideWindowOf(controller: state.currentController)
        InterfaceReducer.showWindowOf(controller: mainWindowController)
        
        result = InterfaceState(state,
                                currentController: mainWindowController)
        
        
    case .updateScreen(let scene):
        
        let window = WindowInterface(scene: scene,
                                     sidebarHidden: state.mainWindow.sidebarHidden)
        result = InterfaceState(state,
                                mainWindow: window)
        
    case .toggleSidebar:
        
        let window = WindowInterface(scene: state.mainWindow.activeScene,
                                     sidebarHidden: !state.mainWindow.sidebarHidden)
        result = InterfaceState(state,
                                mainWindow: window)
        
    case .gallery(let galleryAction):
        
        switch(galleryAction) {
            
        case .changeGridItem(let dimension):
            let gallery = GalleryInterface(gridItemSize: dimension)
            
            result = InterfaceState(state,
                                    gallery: gallery)
        }
        
    case .app(let appAction):
        
        switch appAction {
        
        case .showInFinder(let url):
        
            InterfaceReducer.showInFinder(url: url)
            result = state
        
        case .openUrl(let url):
        
            InterfaceReducer.open(url: url)
            result = state
        
        case .openPreview:
            
            let panel = QLPreviewPanel.shared()
            
            panel?.makeKeyAndOrderFront(nil)
            panel?.reloadData()
            
            result = state
            
        case .closePreview:
            
            if QLPreviewPanel.sharedPreviewPanelExists(),
                let validPanel = QLPreviewPanel.shared(),
                validPanel.isVisible {
            
                validPanel.orderOut(nil)
                validPanel.close()
            }
            
            result = state
        }
    }
    
    print("got state: \(result)")
    
    return result
}

class InterfaceReducer {
    
    static func showWindowOf(controller: NSWindowController) {
        
        controller.showWindow(self)
        
        guard let validWindow = controller.window else {
            
            return
        }
        
        validWindow.collectionBehavior = [.moveToActiveSpace, .participatesInCycle, .managed]
        validWindow.makeKeyAndOrderFront(self)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
    
    static func hideWindowOf(controller: NSWindowController) {
        
        controller.window?.orderOut(self)
        controller.dismissController(self)
    }
    
    static func loadSplashScreenViewController() -> NSViewController? {
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let previewIdentifier = NSStoryboard.SceneIdentifier("SplashScreenViewController")
        
        let result = storyboard.instantiateController(withIdentifier: previewIdentifier) as? NSViewController
        
        return result
    }
    
    static func loadMainWindowController() -> NSWindowController? {
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let previewIdentifier = NSStoryboard.SceneIdentifier("MainWindowController")
        
        guard let result = storyboard.instantiateController(withIdentifier: previewIdentifier) as? NSWindowController  else {
            
            return nil
        }
        
//        if let screen = NSScreen.main {
//            let frame = screen.visibleFrame as CGRect
//            let previewFrame = frame.insetBy(dx: frame.size.width / 5,
//                                             dy: frame.size.height / 5)
//            result.window?.setFrame(previewFrame,
//                                    display: false,
//                                    animate: false)
//        }
        
        return result
    }
    
    static func open(url: URL) {
        
        NSWorkspace.shared.open(url)
    }
    
    static func showInFinder(url: URL) {
        
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }
    
    static func interfaceAction(for toolbarButton: ToolbarButton,
                                activeScene: UIScene) -> InterfaceAction {

        switch toolbarButton {
            
        case .settings:
            
            guard activeScene != .settings else {
                return InterfaceAction.updateScreen(forScene: .gallery)
            }
            return InterfaceAction.updateScreen(forScene: .settings)
            
        case .sidebar:
            
            return InterfaceAction.toggleSidebar
        }
    }
    
    static func panels(for scene: UIScene) -> PanelsState {
        
        switch scene {
        
        case .gallery:
            
            return PanelsState(left: .folders,
                               centerTop: .gallery,
                               centerBottom: .none,
                               right: .none,
                               thickness: ThicknessContainer(left: .fraction(value: 0.1),
                                                             centerBottom: .points(value: 0),
                                                             right: .fraction(value: 0)))
                
        case .settings:
            
            return PanelsState(left: .folders,
                               centerTop: .settings,
                               centerBottom: .none,
                               right: .none,
                               thickness: ThicknessContainer(left: .fraction(value: 0.1),
                                                             centerBottom: .points(value: 0),
                                                             right: .fraction(value: 0)))
        }
    }
}
