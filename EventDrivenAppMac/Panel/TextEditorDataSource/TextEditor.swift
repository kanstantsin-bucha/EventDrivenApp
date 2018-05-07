//
//  PeopleEditorLogic.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 2/9/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import RxSwift


class TextEditor: TextEditorLogic {
    
    private let disposeBag = DisposeBag()
    private var strings: [String] = []
    
    var textEditor: TextEditorRepresentation
    
    init(textEditor: TextEditorRepresentation) {
        
        self.textEditor = textEditor
    }
    
    func initiate() {
        
        let title = NSLocalizedString("Switch Title", comment: "")
        textEditor.show(hint: NSLocalizedString("List Title", comment: ""))
        
        self.textEditor.showSwitch(title: title,
                                   state: false)
        
//        User.did(.people(action: .reload))
        
        let disposable = dataStore.observable.asObservable().subscribe(onNext: { [weak self] (state) in
            
            guard let strongSelf = self else {
                return
            }
            
        })
        
        disposeBag.insert(disposable)
    }
    
    func reload() {
        
//        User.did(.people(action: .reloadPeople))
//        User.did(.settings(action: .finishEditing))
    }
    
    func save(text: String?) {
        
//        User.did(.people(action: .updatePeople(peopleText: text)))
//        User.did(.people(action: .savePeople))
//        User.did(.settings(action: .finishEditing))
    }
    
    func update(text: String?) {
        
//        User.did(.people(action: .updatePeople(peopleText: text)))
    }
    
    func didSwitch(on: Bool) {
        
//        User.did(.people(action: .makeContactsLookup(enabled: on)))
    }
    
}

