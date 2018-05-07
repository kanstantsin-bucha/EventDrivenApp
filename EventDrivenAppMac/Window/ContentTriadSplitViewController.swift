//
//  ContentTriadSplitViewController.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 12/24/17.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Cocoa
import RxSwift

class ContentTriadSplitController: NSSplitViewController {
    
    private let disposeBag = DisposeBag()
    private var interface: WindowInterface = WindowInterface()
    
    var leftPanel: Panel?
    var rightPanel: Panel?
    var thickness: ThicknessContainer?
    
    var thicknessApplied: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let disposable = interfaceStore.observable.asObservable().subscribe(onNext: { [weak self] (state) in
            
            guard self?.interface !== state.mainWindow else {
                return
            }
            
            self?.interface = state.mainWindow
            
            let panels = state.mainWindow.panels
            self?.thickness = panels.thickness
            
            let newLeft = panels.left
            let newRight = panels.right
            
            DispatchQueue.main.async { [weak self] in
                
                guard let strongSelf = self else {
                    return
                }
                
                var items: [NSSplitViewItem] = []
                
                if strongSelf.leftPanel != newLeft {
                    strongSelf.leftPanel = newLeft
                    let item = strongSelf.loadLeftItem(for: newLeft)
                    items.append(item)
                } else {
                    items.append(strongSelf.splitViewItems[0])
                }
                
                items.append(strongSelf.splitViewItems[1])
                
                if strongSelf.rightPanel != newRight {
                    strongSelf.rightPanel = newRight
                    let item = strongSelf.loadRightItem(for: newRight)
                    items.append(item)
                } else {
                    items.append(strongSelf.splitViewItems[2])
                }
                
                self?.thicknessApplied = false
                strongSelf.applyThickness(strongSelf.thickness, to: items)
                items[0].isCollapsed = state.mainWindow.sidebarHidden
                strongSelf.splitViewItems = items
                
            }
        })
        
        disposeBag.insert(disposable)
    }
    
    override func viewDidLayout() {

        super.viewDidLayout()
        applyThickness(self.thickness, to: splitViewItems)
    }
    
    func applyThickness(_ thickness: ThicknessContainer?,
                        to items: [NSSplitViewItem]) {
        
        
        // the true magic is the hidden long label in map panel
        /* This long label is a hack that allow map panel shrink all other panels in splitView and expand itself to maximum available width. The label is the most valueble element when split view auto layout calculates desired view width. The splitViewItem properties for the desired with as a desired fraction can not override simple label in the view. That's a very strange behaviour thought. */
        
        guard thicknessApplied == false else {
            
            return
        }
        
        guard let thickness = thickness,
              items.count == 3 else {
                
            return
        }
        
        thicknessApplied = true
        
        let boundsWidth  = view.bounds.size.width
        var width = boundsWidth
        var fraction: CGFloat = 1.0
        
        if items[0].isCollapsed == false {
            
            switch(thickness.left) {
                
            case .flexible:
                
                let minWidth = CGFloat(150)
                items[0].maximumThickness = NSSplitViewItem.unspecifiedDimension
                items[0].minimumThickness = minWidth
                
                width -= CGFloat(minWidth)
                let leftFraction = CGFloat(minWidth) / boundsWidth
                items[0].preferredThicknessFraction = leftFraction
                fraction -= leftFraction
                
                items[0].holdingPriority = NSLayoutConstraint.Priority(250)
                
            case .points(let desiredWidth):
                
                items[0].minimumThickness = CGFloat(desiredWidth)
                items[0].maximumThickness = CGFloat(desiredWidth)
                width -= CGFloat(desiredWidth)
                
                let leftFraction = CGFloat(desiredWidth) / boundsWidth
                items[0].preferredThicknessFraction = leftFraction
                fraction -= CGFloat(desiredWidth) / boundsWidth
                
                items[0].holdingPriority = NSLayoutConstraint.Priority(250)
                
            case .fraction(let desiredFraction):
                
                items[0].preferredThicknessFraction = CGFloat(desiredFraction)
                fraction -= CGFloat(desiredFraction)
                width -= boundsWidth * CGFloat(desiredFraction)
                
                items[0].holdingPriority = NSLayoutConstraint.Priority(250)
            }
        }
        
        switch(thickness.right) {
            
        case .flexible:
            
            let minWidth = CGFloat(200)
            items[2].maximumThickness = NSSplitViewItem.unspecifiedDimension
            items[2].minimumThickness = minWidth
            
            width -= CGFloat(minWidth)
            let leftFraction = CGFloat(minWidth) / boundsWidth
            items[2].preferredThicknessFraction = leftFraction
            fraction -= leftFraction
            
            items[2].holdingPriority = NSLayoutConstraint.Priority(250)
            
        case .points(let desiredWidth):
            
            items[2].minimumThickness = CGFloat(desiredWidth)
            items[2].maximumThickness = CGFloat(desiredWidth)
            width -= CGFloat(desiredWidth)
            
            let rightFraction = CGFloat(desiredWidth) / boundsWidth
            items[2].preferredThicknessFraction = rightFraction
            fraction -= CGFloat(desiredWidth) / boundsWidth
            
            splitViewItems[1].maximumThickness = CGFloat(desiredWidth)
            splitViewItems[1].minimumThickness = CGFloat(desiredWidth)
            
            items[0].holdingPriority = NSLayoutConstraint.Priority(250)
            
        case .fraction(let desiredFraction):
            
            items[2].preferredThicknessFraction = CGFloat(desiredFraction)
            fraction -= CGFloat(desiredFraction)
            width -= boundsWidth * CGFloat(desiredFraction)
            
            items[2].holdingPriority = NSLayoutConstraint.Priority(250)
        }
        
        switch(thickness.center) {
            
        case .flexible:
            
            items[1].preferredThicknessFraction = fraction
            items[1].holdingPriority = NSLayoutConstraint.Priority(200)
            
        case .points(let desiredWidth):
            
            items[1].minimumThickness = CGFloat(desiredWidth)
            items[2].preferredThicknessFraction = fraction
            items[1].holdingPriority = NSLayoutConstraint.Priority(50)
            
        case .fraction(let desiredFraction):
            
            items[1].preferredThicknessFraction = CGFloat(desiredFraction)
            items[1].maximumThickness = width
            items[2].preferredThicknessFraction = fraction - CGFloat(desiredFraction)
            items[1].holdingPriority = NSLayoutConstraint.Priority(200)
        }
    }
    
    //MARK: - logic -

    func loadLeftItem(for panel: Panel) -> NSSplitViewItem {
        
        let controller = PanelFactoy.loadViewController(for: panel)
        let leftItem = NSSplitViewItem(viewController: controller)
        leftItem.collapseBehavior = .preferResizingSiblingsWithFixedSplitView
        return leftItem
    }
    
    func loadCenterItem() -> NSSplitViewItem {
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let sceneId = NSStoryboard.SceneIdentifier("centerSplit")
        let controller = storyboard.instantiateController(withIdentifier: sceneId) as! NSViewController
        
        let centerItem = NSSplitViewItem(viewController: controller)
        return centerItem
    }
    
    func loadRightItem(for panel: Panel) -> NSSplitViewItem {
        
        let controller = PanelFactoy.loadViewController(for: panel)
        let rightItem = NSSplitViewItem(viewController: controller)
        return rightItem
    }
}
