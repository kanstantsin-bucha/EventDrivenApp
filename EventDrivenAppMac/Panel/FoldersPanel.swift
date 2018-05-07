//
//  FoldersViewController.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 12/17/17.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import RxSwift

class FoldersPanel : NSViewController {
    
    private let disposeBag = DisposeBag()
    private var foldersData: FoldersData = FoldersData()

    @IBOutlet weak var foldersList: NSOutlineView!
    @IBOutlet var tableRowView: QMTableRowView!
    @IBOutlet weak var foldButton: QMButton!
    
    @IBAction func addFolderDidClick(_ sender: Any) {
        
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        
        panel.begin { [weak self] (response) in
            guard response == NSApplication.ModalResponse.OK,
                  let dir = panel.urls.first else {
                return
            }
            
            print("received choise of \(dir)")
            
            self?.addDirectory(dir: dir)
        }
        
    }
    
    @IBAction func foldAllDidClicked(_ sender: Any) {
        
        foldersList.collapseItem(nil, collapseChildren: true)
        self.foldButton.isHidden = true
    }
    
    /**
     in QMOutlineView we override event handler so
     menu presents only for top level items
    */
    
    @IBAction func deleteMenuItemDidClick(_ menuItem: NSMenuItem) {
     
        guard let folderToDelete = menuItem.representedObject as? FolderItem else {
            return;
        }
        
        User.did(.folder(action: .deleteRoot(folder: folderToDelete)))
    }
    
    //MARK: - life cycle -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let disposable = dataStore.observable.asObservable().subscribe(onNext: { [weak self] state in
            
            guard let strongSelf = self else {
                return
            }
            
            guard strongSelf.foldersData !== state.folders else {
                return
            }
            
            strongSelf.foldersData = state.folders
            
            self?.reloadData()
            
            if let selectedItem = state.active.folder {
                
                self?.selectItem(sameAs: selectedItem)
            }
        })
        
        disposeBag.insert(disposable)
        
        if let dropView = view as? DropView {
            dropView.delegate = self
        }
    }
    
    //MARK: - logic -
    
    func reloadData() {
        
        self.foldersList.reloadData()
        self.foldButton.isHidden = true
    }
    
    func selectItem(sameAs item: FolderItem) {
        //TODO: expand list and select item if possible
    }
    
    func addDirectory(dir: URL) {
        User.did(.folder(action: .appendRoot(folderURL: dir)))
    }
    
    func load(folder: FolderItem) {
        
        folder.loaded = true
        let _ = folder.grantAccess()
        
            let enumerator = FileManager.default
                .enumerator(at: folder.getUrl(),
                            includingPropertiesForKeys: [.isDirectoryKey],
                            options: [FileManager.DirectoryEnumerationOptions.skipsHiddenFiles,
                                     FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants,
                                     FileManager.DirectoryEnumerationOptions.skipsPackageDescendants])
            
        guard let subitems = enumerator else {
            folder.denyAccess()
            return
        }
    
        var childItems: [FolderItem] = []
        
        for url in subitems {
            guard let url = url as? URL,
                DataReducer.isFolderAvailable(fileURL: url) else {
                    continue
            }
            
            let childFolderItem = FolderItem.using(url)
            
            childItems.append(childFolderItem)
        }
        
        childItems.sort{ FolderItem.compareItems($0, $1) == .orderedAscending }
        
        folder.childItems = childItems
    
        folder.denyAccess()
    }
    
}

extension FoldersPanel : DropViewDelegate {
    
    func didReceiveDrop(ofFileURL fileURL: URL) {
       
        addDirectory(dir: fileURL)
        
    }
    
    func isAvailable(fileURL: URL) -> Bool {
        
        let result = DataReducer.isFolderAvailable(fileURL: fileURL)
        return result
        
    }
    
}


extension FoldersPanel : NSOutlineViewDataSource, QMOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, canShowMenuFor item: Any?) -> Bool {
        
        guard let validItem = item as? FolderItem else {
            
            return false
        }
        
        // we assume that default items do not backed in a realm database
        // while user items does
        
        let result = validItem.realmBacked
        return result
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        guard item != nil else {
            
            return foldersData.items.count
        }
        
        guard let folder = item as? FolderItem  else {
            return 0
        }
        
        let result = folder.childItems.count
        return result
        
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        
        guard item != nil else {
            
            return foldersData.items[index]
        }
        
        guard let folder = item as? FolderItem else {
            return FolderItem()
        }
        
        let result = folder.childItems[index]
        return result
        
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        
        guard let folder = item as? FolderItem else {
            return false
        }
        
        
        if folder.loaded == false {
            load(folder: folder)
        }
        
        let result = folder.childItems.count > 0
        
        return result
        
    }
    
    func outlineView(_ outlineView: NSOutlineView,
                     viewFor tableColumn: NSTableColumn?,
                     item: Any) -> NSView? {
        guard tableColumn != nil,
              tableColumn!.identifier == NSUserInterfaceItemIdentifier("FolderTitle"),
              let folderItem = item as? FolderItem else {
            return nil
        }
        
        let row = outlineView.row(forItem: item)
        let rowLevel = outlineView.level(forRow: row)
        
        let cellId = rowLevel == 0 ? NSUserInterfaceItemIdentifier("FolderCell")
                                   : NSUserInterfaceItemIdentifier("FolderCellWhiteText")
       
        let result = outlineView.makeView(withIdentifier: cellId,
                                          owner: self) as? NSTableCellView
        
        result?.textField?.stringValue = folderItem.title
        
        return result
    }
    
    func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any) -> NSTableRowView? {
        
        let result = QMTableRowView()
        
        result.selectedColor = tableRowView.selectedColor
        result.rootColor = tableRowView.rootColor
        result.nestedColor = tableRowView.nestedColor
    
        return result
    }
    
    func outlineView(_ outlineView: NSOutlineView, didAdd rowView: NSTableRowView, forRow row: Int) {
        
        guard let view = rowView as? QMTableRowView else {
            return
        }
        
        let rowLevel = outlineView.level(forRow: row)
        
        if rowLevel > 0 {
            self.foldButton.isHidden = false
        }
        
        let color = rowLevel == 0 ? view.rootColor
                                  : view.nestedColor
        
        view.backgroundColor = color
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        
        User.did(.folder(action: .activate(folder: item as! FolderItem)))
        return true
    }
    
}
