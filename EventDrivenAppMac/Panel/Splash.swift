//
//  Splash.swift
//  TrueBucha
//
//  Created by Tony Knight on 4/17/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Cocoa

class Splash: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    

    @IBAction func backMain(_ sender: Any) {
        
        interfaceStore.dispatch(InterfaceAction.displayMainScreen)
    }
}
