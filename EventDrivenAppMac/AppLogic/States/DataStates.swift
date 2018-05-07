//
//  DataState.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 1/29/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import RealmSwift
import LocationInfo


class FoldersData {
    
    let items: [FolderItem]
    
    init(items: [FolderItem] = []) {
        
        self.items = items
    }
    
    static func initial() -> FoldersData {
        
        var items: [FolderItem] = []
        
        if let home = ProcessInfo.processInfo.environment["HOME"] {
            let userDir = URL(fileURLWithPath: home)
            let folder = FolderItem.using(userDir)
            
            items.append(folder)
        }
        
        let realm = try! Realm()
        let folders = realm.objects(FolderItem.self)
        items.append(contentsOf: folders)
        
        items.sort{ FolderItem.compareItems($0, $1) == .orderedAscending }
        let result = FoldersData(items: items)
        
        return result
    }
}

class GalleryData {
    
    let items: Set<GalleryItem>
    
    init(_ items: Set<GalleryItem> = Set<GalleryItem>()) {
        
        self.items = items
    }
}

@objc enum ImageType: Int {
    case dng, tif, png, jpg
}

class ImageFileSettingsData {
    
    let availableExtensions: [String]
    let availableTypes: [ImageType]
    
    init(availableTypes: [ImageType] = Settings.program.defaultImageTypes) {
        
        self.availableTypes = availableTypes
        self.availableExtensions = ImageFileSettingsData.extensions(for: availableTypes)
    }
    
    //MARK: - logic -
    static func extensions(for types: [ImageType]) -> [String] {
        
        var result: [String] = []
        
        for type in types {
            
            switch type {
                
            case .dng:
                
                result.append("dng")
                
            case .tif:
                
                result.append("tif")
                result.append("tiff")
                
            case .png:
                
                result.append("png")
                
            case .jpg:
                
                result.append("jpg")
                result.append("jpeg")
            }
        }
        return result
    }
}

class SettingsData {
    
    let imageFile: ImageFileSettingsData
    
    init(imageFile: ImageFileSettingsData = ImageFileSettingsData()) {
        
        self.imageFile = imageFile
    }
    
    init(using storage: SettingsStorage) {
        
        let imageFileSettings = ImageFileSettingsData(availableTypes: storage.availableTypes)
        self.imageFile = imageFileSettings
    }
}


class ActiveData {
    
    let folder: FolderItem?
    let galleryItems: Set<GalleryItem>
    
    init(folder: FolderItem? = nil,
         galleryItems: Set<GalleryItem> = Set<GalleryItem>()) {
        
        self.folder = folder
        self.galleryItems = galleryItems
    }
}

typealias GalleryItemsBlock = (() -> [GalleryItem])

struct DataState {
    
    let folders: FoldersData
    let gallery: GalleryData
    let active: ActiveData
    let settings: SettingsData
    
    let displayedGalleryItems: [GalleryItem]
    let previewGalleryItemsBlock: GalleryItemsBlock
    
    init(folders: FoldersData,
         gallery: GalleryData,
         active: ActiveData,
         settings: SettingsData) {
        
        self.folders = folders
        self.gallery = gallery
        self.active = active
        self.settings = settings
        
        let displayedGalleryItems = DataState.displayedGalleryItemsUsing(items: gallery.items)
        
        self.displayedGalleryItems = displayedGalleryItems
        self.previewGalleryItemsBlock = DataState.previewItemsBlock(selectedGalleryItems: active.galleryItems,
                                                                    displayedGalleryItems: displayedGalleryItems)
    }
    
    init(_ precedent: DataState,
         folders: FoldersData? = nil,
         gallery: GalleryData? = nil,
         active: ActiveData? = nil,
         settings: SettingsData? = nil) {
        
        self.folders = folders ?? precedent.folders
        let gallery = gallery ?? precedent.gallery
        self.gallery = gallery
        let active = active ?? precedent.active
        self.active = active
        self.settings = settings ?? precedent.settings
    
        let displayedGalleryItems = DataState.displayedGalleryItemsUsing(items: gallery.items)
        
        self.displayedGalleryItems = displayedGalleryItems
        self.previewGalleryItemsBlock = DataState.previewItemsBlock(selectedGalleryItems: active.galleryItems,
                                                                    displayedGalleryItems: displayedGalleryItems)
    }
    
    static func previewItemsBlock(selectedGalleryItems: Set<GalleryItem>,
                                  displayedGalleryItems: [GalleryItem]) -> GalleryItemsBlock  {
        
        let result: GalleryItemsBlock = {
            
            guard selectedGalleryItems.count < 2 else {
                
                let result = selectedGalleryItems.sorted { $0 < $1 }
                return result
            }
            
            guard let selected = selectedGalleryItems.first else {
                
                let result = displayedGalleryItems
                return result
            }
            
            
            let parts = displayedGalleryItems.split(separator: selected, maxSplits: 2, omittingEmptySubsequences: false)
            
            guard parts.count == 2 else {
                
                let result = displayedGalleryItems
                return result
            }
            
            var result: [GalleryItem] = []
            
            result.append(selected)
            result.append(contentsOf: parts[1])
            result.append(contentsOf: parts[0])
            
            return result
        }
        
        return result
    }
    
    static func displayedGalleryItemsUsing(items: Set<GalleryItem>) -> [GalleryItem] {
    
        var result = Array(items)
        result.sort { $0 < $1 }
    
        return result
    }
}

//MARK: - convertible -


extension SettingsData : CustomStringConvertible {
    
    public var description: String {
        
        var result = "<\(String(describing: type(of: self))) imageFile: \(imageFile) "
        
        result.append(">")
        
        return result
    }
}

extension ImageFileSettingsData : CustomStringConvertible {
    
    public var description: String {
        
        var result = "<\(String(describing: type(of: self))) availableTypes: \" \(availableExtensions) \""
        result.append(">")
        
        return result
    }
}

extension ActiveData : CustomStringConvertible {
    
    public var description: String {
    
        var result = "<\(String(describing: type(of: self))) "
        
        if let folderItem = folder {
            
            result.append(", folder: \(folderItem)")
            result.append(", selected gallery items count: \(galleryItems.count)")
        }
       
        result.append(">")
        
        return result
    }
}

extension GalleryData : CustomStringConvertible {
    
    public var description: String {
        
        let result = "<\(String(describing: type(of: self))) \(items.count) items>"
        
        return result
    }
}

extension DataState: CustomStringConvertible {
    
    var description: String {
        
        let activeString = "\n acitive: \(active)"
        let foldersString = "\n folders: \(folders)"
        let galleryString = "\n gallery: \(gallery)"
        let settingsString = "\n settings \(settings)"
        
        let result = "<\(String(describing: type(of: self))) \(activeString) \(foldersString) \(galleryString) \(settingsString)>"
        return result
    }
}
