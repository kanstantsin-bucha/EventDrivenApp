//
//  File.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 1/8/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Cocoa
import FlatButton


protocol TextEditorLogic {
    
    func save(text: String?)
    func update(text: String?)
    func reload()
    func initiate()
    func didSwitch(on: Bool)
}

protocol TextEditorRepresentation {
    
    var logic: TextEditorLogic? { get set }
    func show(hint: String)
    func show(text: String)
    func showSwitch(title: String, state on: Bool)
}

class TextEditorPanel: NSViewController {
    
    var logic: TextEditorLogic? = nil
    
    @IBOutlet var textEditor: NSTextView!
    @IBOutlet weak var reloadButton: FlatButton!
    @IBOutlet weak var saveButton: FlatButton!
    @IBOutlet weak var descriptionTitle: NSTextField!
    
    @IBOutlet weak var switchButton: QMButton!
    
    //MARK: - actions -
    
    @IBAction func switchDidClick(_ sender: NSButton) {
        
        logic?.didSwitch(on: sender.state == .on)
    }
    
    @IBAction func reloadDidClick(_ sender: Any) {
        
        User.did(.openUserManual)
    }
    
    @IBAction func saveDidClick(_ sender: Any) {
        
        saveData()
    }
    
    //MARK: - life cycle -
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        textEditor.string = ""
        logic?.initiate()
    }
    
    //MARK: - logic -

    func saveData() {
        
        let placestext = textEditor.textStorage?.string
        
        logic?.save(text: placestext)
    }
}

extension TextEditorPanel: NSTextViewDelegate {
    
    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        
        if commandSelector == #selector(NSTextView.insertNewline) {
            logic?.update(text: textView.textStorage?.string)
        }
        
        return false
    }
}

extension TextEditorPanel: TextEditorRepresentation {
    
    func show(hint: String) {
        
        descriptionTitle.stringValue = hint
    }
    
    func show(text: String) {
        
        textEditor.string = text
    }
    
    func showSwitch(title: String, state on: Bool) {
        
        switchButton.state = on ? .on
                                : .off
        switchButton.title = title
        switchButton.isHidden = false
    }
}
