//
//  FolderItem.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 12/21/17.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import RealmSwift
import BuchaSwift

enum FolderItemError: Error {
    case failedResolveUrl(desc: String)
}

class FolderItem: Object {
    
    var loaded = false
    var childItems: [FolderItem] = []
    
    @objc dynamic var realmBacked: Bool = false
    @objc dynamic var path: String = ""
    @objc dynamic var bookmark: Data?
    
    private var url: URL?
    
    var title: String {
        return (path as NSString).lastPathComponent
    }

    //MARK: - life cycle -
    
    static func using(_ url: URL) -> FolderItem {
        
        let result = FolderItem()
        result.update(using: url)
        
        return result
    }
    
    deinit {
        denyAccess()
    }
    
    //MARK: - interface -
    
    static func compareItems(_ lhs: FolderItem, _ rhs: FolderItem) -> ComparisonResult {
        let left = lhs.title
        let right = rhs.title
        return left.localizedStandardCompare(right)
    }
    
    func getUrl() -> URL {
        
        if let validUrl = url,
            FileManager.default.fileExists(atPath: validUrl.path) {
            return validUrl
        }
        
        guard let oldBookmark = bookmark else {
            url = URL(fileURLWithPath: path)
            return url!
        }
        
        var stale = false
        
        let resolvedUrl: URL?
        do {
            
            resolvedUrl = try URL(resolvingBookmarkData: oldBookmark,
                                  options: .withSecurityScope,
                                  relativeTo: nil,
                                  bookmarkDataIsStale: &stale)
            print("resolved url \(String(describing: resolvedUrl))")
            
        } catch let error {
            
            resolvedUrl = nil
            print("resolve url failed \(error)")
        }
        
        guard let result = resolvedUrl else  {
            url = URL(fileURLWithPath: path)
            return url!
        }
        
        url = result
        
        if stale {
            _ = grantAccess()
            updateRealm(using: result)
        }
        
        return result
    }
    
    func grantAccess() -> Bool {
        
        let url = getUrl()
        
        let result = url.startAccessingSecurityScopedResource()
        
        print("request access \(result ? "succeed" : "failed") to folder: \"\(url)\"")
       
        return result
    }
    
    func denyAccess() {
        
        let url = getUrl()
        
        url.stopAccessingSecurityScopedResource()
    }
    
    func updateRealm(using url: URL) {
        
        guard self.realmBacked else {
            
            update(using: url)
            return
        }
        
        let realm = try! Realm()
        try! realm.write {
            
            update(using: url)
            realm.add(self)
        }
    }
    
    func update(using url: URL) {

        path = url.path
        bookmark = bookmark(using: url)
    }
    
    //MARK: - logic -
    
    func bookmark(using url: URL) -> Data? {
        let options = URL.BookmarkCreationOptions.withSecurityScope
        let result: Data?
        do {
            result = try url.bookmarkData(options: options,
                                          includingResourceValuesForKeys: nil,
                                          relativeTo: nil)
            print("create bookmark \(String(describing:result)) fo ulr: \(url)")
        } catch let error {
            print("error: \(error)")
            result = nil
        }
        
        return result
    }
    
    func contains(item: FolderItem) -> Bool {
        
        let containsFlatChild = childItems.contains { childItem in
            return childItem === item
        }
        
        guard containsFlatChild == false else {
            return true
        }
        
        for childItem in childItems {
            if childItem.contains(item: item) {
                return true
            }
        }
        
        return false
    }
    
}

extension FolderItem {
    
    override var description: String {
        
        let loadedDescription = loaded == false ? "not loaded>"
                                                : "has \(childItems.count) child items>"
        let result = "<\(String(describing: type(of: self))):  \(String(describing: title)), \(loadedDescription)"
        return result
    }
    
}
