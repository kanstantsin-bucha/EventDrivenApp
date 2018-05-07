//
//  CenterSplitViewController.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 1/9/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Cocoa
import RxSwift

class CenterSplitViewController: NSSplitViewController {
    
    private let disposeBag = DisposeBag()
    private var interface: WindowInterface = WindowInterface()
    
    var topPanel: Panel?
    var bottomPanel: Panel?
    var thickness: ThicknessContainer?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let disposable = interfaceStore.observable.asObservable().subscribe(onNext: { [weak self] (state) in
            
            guard self?.interface !== state.mainWindow else {
                return
            }
            
            self?.interface = state.mainWindow
        
            let panels = state.mainWindow.panels
            self?.thickness = panels.thickness
            
            let newTop = panels.centerTop
            let newBottom = panels.centerBottom
            
            DispatchQueue.main.async { [weak self] in
                
                guard let strongSelf = self else {
                    return
                }
                
                if strongSelf.topPanel != newTop {
                    strongSelf.topPanel = newTop
                    strongSelf.splitViewItems[0] = strongSelf.loadItem(for: newTop)
                }
                
                if strongSelf.bottomPanel != newBottom {
                    strongSelf.bottomPanel = newBottom
                    strongSelf.splitViewItems[1] = strongSelf.loadItem(for: newBottom)
                }
                
                self?.applyThickness(self?.thickness)
            }
        })
        
        disposeBag.insert(disposable)
    }
    
    override func viewWillLayout() {
        
        super.viewWillLayout()
        
        applyThickness(self.thickness)
    }
    
    //MARK: - logic -
    
    func applyThickness(_ thickness: ThicknessContainer?) {
        
        guard let thickness = thickness else {
            return
        }
        
        let height = view.bounds.size.height
        
        switch(thickness.centerTop) {
            
        case .flexible:
            
            splitViewItems[0].minimumThickness = 100
            
        case .points(let desiredHeight):
            
            splitViewItems[0].maximumThickness = CGFloat(desiredHeight)
            splitViewItems[0].minimumThickness = CGFloat(desiredHeight)
            
        case .fraction(let desiredFraction):
            
            splitViewItems[0].maximumThickness = height * CGFloat(desiredFraction)
            splitViewItems[0].minimumThickness = height * CGFloat(desiredFraction)
            
        }
        
        switch(thickness.centerBottom) {
            
        case .flexible:
            
            splitViewItems[1].minimumThickness = 100
            
        case .points(let desiredHeight):
            
            splitViewItems[1].maximumThickness = CGFloat(desiredHeight)
            splitViewItems[1].minimumThickness = CGFloat(desiredHeight)
            
        case .fraction(let desiredFraction):
            
            splitViewItems[1].maximumThickness = height * CGFloat(desiredFraction)
            splitViewItems[1].minimumThickness = height * CGFloat(desiredFraction)
            
        }
    }
    
    func loadItem(for panel: Panel) -> NSSplitViewItem  {
        
        let controller = PanelFactoy.loadViewController(for: panel)
        let result = NSSplitViewItem(viewController: controller)
        
        return result
    }
}
