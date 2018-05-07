//
//  SettingsPanel.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 1/9/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Cocoa

class SettingsPanel: NSViewController {
    
    @IBOutlet weak var dngButton: QMButton!
    @IBOutlet weak var jpgButton: QMButton!
    @IBOutlet weak var pngButton: QMButton!
    @IBOutlet weak var tiffButton: QMButton!
    
    @IBAction func saveDidClick(_ sender: Any) {
        
        let types = composeAvailableImageTypes()
        User.did(.settings(action: .updateImageTypes(types:types)))
        User.did(.settings(action: .finishEditing))
    }
    
    @IBAction func cancelDidClick(_ sender: Any) {
        
        let url = Settings.program.userManualUrl
        interfaceStore.dispatch(InterfaceAction.app(action: .openUrl(url: url)))
    }
    

    @IBAction func makeCopyDidClick(_ sender: Any) {
        
    }
    
    @IBAction func useDateFormatDidClick(_ sender: Any) {
        
    }
    
    
    @IBAction func fileTypesDidClick(_ sender: Any) {
        
    }
    
    @IBAction func showBackupsFolderDidClick(_ sender: Any) {
     
        User.did(.settings(action: .showBackupsFolderInFinder))
    }
    
    //MARK: - life cycle -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        updateUI(using: dataStore.observable.value.settings)
    }
    
    //MARK: - logic -
    
    func updateUI(using settings: SettingsData) {
    
        dngButton.state = settings.imageFile.availableTypes.index(of: .dng) != nil ? .on : .off
        tiffButton.state = settings.imageFile.availableTypes.index(of: .tif) != nil ? .on : .off
        pngButton.state = settings.imageFile.availableTypes.index(of: .png) != nil ? .on : .off
        jpgButton.state = settings.imageFile.availableTypes.index(of: .jpg) != nil ? .on : .off
    }
    
    func composeAvailableImageTypes() -> [ImageType] {
        
        var result: [ImageType] = []
        
        if dngButton.state == .on {
            
            result.append(.dng)
        }
        
        if tiffButton.state == .on {
            
            result.append(.tif)
        }
        
        if pngButton.state == .on {
            
            result.append(.png)
        }
        
        if jpgButton.state == .on {
            
            result.append(.jpg)
        }
        
        return result
    }
}
