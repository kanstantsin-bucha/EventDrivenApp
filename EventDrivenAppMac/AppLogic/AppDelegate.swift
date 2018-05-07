//
//  AppDelegate.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 12/7/17.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Cocoa


@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        integration.enable()
        
        FileManager.default.ensureDirectoryExists(at: Settings.program.backupFolder)
        
        interfaceStore.dispatch(InterfaceAction.displaySplashScreen)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Settings.splashScreen.duration) {
            
            interfaceStore.dispatch(InterfaceAction.displayMainScreen)
        }
    }
    
    //MARK - menu actions -
    
    @IBAction func openManual(_: AnyObject) {
        
        User.did(.openUserManual)
    }
    
    @IBAction func openTutorials(_: AnyObject) {
        
        User.did(.openTutorial)
    }
    
    @IBAction func showFeedbackDialog(_: AnyObject?)  {
        
        User.did(.showFeedbackDialog)
    }
    
    @IBAction func checkForUpdates(_ sender: AnyObject?) {
        
        User.did(.checkForUpdates)
    }
    @IBAction func displaySplashScreen(_ sender: AnyObject?) {
        
        interfaceStore.dispatch(InterfaceAction.displaySplashScreen)
    }

}

