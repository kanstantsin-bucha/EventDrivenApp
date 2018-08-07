//
//  ViewController.swift
//  EventDrivenApp
//
//  Created by Kanstantsin Bucha on 6/29/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import UIKit
import Parse
import ReactiveReSwift

class ViewController: UIViewController {

    @IBOutlet weak var counterLabel: UILabel!
    private let disposeBag = SubscriptionReferenceBag()
    
    //MARK: - life cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disposeBag += dataStore.observable.subscribe { state in
            
            self.counterLabel.text = String(state.counter)
        }
        
        disposeBag += interfaceStore.observable.subscribe { state in
            
            self.view.backgroundColor = state.viewControllerBackground
        }
        
        testParseQuery()
    }
    
    //MARK: - actions -
    
    @IBAction func downTouch(_ sender: AnyObject) {
        
        User.did(.decreaseCounter)
    }
    
    @IBAction func upTouch(_ sender: AnyObject) {
        
        User.did(.increaseCounter)
    }

    func testParseQuery() {
        
        let query = PFQuery(className: "EventDrivenAppConfig")
        let objects = try? query.findObjects() //as Array<PFObject>
        
        guard let config = objects?.last else {
            
            print("[Error]: Failed to fetch parse server")
            return
        }
        
        print("parse message: \(config["testSequence"])")
    }
}

