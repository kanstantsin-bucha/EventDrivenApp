//
//  QMListBoxController.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 2/13/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import BuchaSwift

class ListBoxController<Element: AnyObject>: NSViewController, NSTableViewDelegate, NSTableViewDataSource
 {
    
    var list: [Element] = [] {
        
        didSet {
            
            guard let table = listTable else {
                return
            }
            
            table.reloadData()
        }
    }
    
    var didSelecListItemAtIndexBlock: DataCompletion<Element>?
    var getObjectTitle: ((_ data: Element) -> (String))?
    
    @IBOutlet var listBox: NSBox!
    @IBOutlet weak var listTable: NSTableView!
    
    
    //MARK: - life cycle -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        listTable.reloadData()
    }
    
    //MARK: - NSTableViewDelegate, NSTableViewDataSource -
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let result = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("rowItem"),
                                        owner: nil) as? NSTableCellView
        let object = list[row]
        
        let title: String
        if let getTitle = getObjectTitle {
            
            title = getTitle(object)
        } else {
            title = String(describing: object)
        }
        
        result?.textField?.stringValue = title
        
        return result
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        return list.count;
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        
        if let block = didSelecListItemAtIndexBlock {
            
            let object = list[row]
            block(object)
        }
        
        return false
    }
    
}
