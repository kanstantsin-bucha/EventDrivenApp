/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Base view controller to be subclassed for any view controller in the stack view.
 */

import Cocoa
import RxSwift

class ToolbarPanel : NSViewController {
    
    private let disposeBag = DisposeBag()
    
    private var interface: WindowInterface? = nil
    
    @IBOutlet weak var settingsButton: NSButton!
    
    @IBOutlet weak var sidebarButton: NSButton!
    
    lazy var buttons: [NSButton] = {
        [settingsButton]
    }()
    
    // MARK: - Actions -
    
    @IBAction func settingsButtonDidClick(_ sender: Any) {
        
        User.did(.toolbar(action: .clicked(button: .settings)))
    }
    
    @IBAction func sidebarButtonDidClick(_ sender: Any) {
        
        User.did(.toolbar(action: .clicked(button: .sidebar)))
    }
    
    
    // MARK: - View Controller Lifecycle -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let disposable = interfaceStore.observable.asObservable().subscribe({ [weak self] state in
            
            guard let strongSelf = self,
                  strongSelf.interface !== state.mainWindow else {
                return
            }
            
            strongSelf.interface = state.mainWindow
            
            guard let interface = strongSelf.interface else {
                return
            }
            
            strongSelf.updateCategoryButtonsFor(scene: interface.activeScene)
            
            let buttonState: NSButton.StateValue = interface.sidebarHidden ? .off : .on
            strongSelf.sidebarButton.state = buttonState
        })
        
        if let dispose = disposable {
            disposeBag.insert(dispose.disposable)
        }
    }
    
    // MARK: - Logic -
    
    func enumerateButtonsUsing(_ closure: (_ button: NSButton) -> ()) {
        
        for button in buttons {
            closure(button)
        }
    }
    
    func updateCategoryButtonsFor(scene: UIScene) {

        enumerateButtonsUsing { (button) in
            button.state = .off
        }

        switch scene {
            case .settings :
                settingsButton.state = .on
            default: break
        }
    }
}
