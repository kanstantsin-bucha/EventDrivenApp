//
//  AppDataReducer.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 1/11/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import Contacts
import ReactiveReSwift
import RealmSwift
import BuchaSwift

import QMGeocoder
import LocationInfo

let dataReducer: Reducer<DataState> = { action, state in
    
    guard let dataAction = action as? DataAction else {
        return state
    }

    Event.data(action: dataAction)
    
    print("==========================")
    print("received data action: \(dataAction)")
    
    let result: DataState
    
    switch dataAction {
        
    case .activateFolder(let item):
        
        let _ = item.grantAccess()
        
        let gallery = GalleryData(DataReducer.loadGalleryItems(from: item))
        
        result = DataState(state,
                           gallery: gallery,
                           active: ActiveData(folder: item))
        
    case .deactivateFolder:
        
        result = DataReducer.deactivateFolderUsing(state)
        
    case .deleteRootFolder(let item):
        
        var processingState = state
        
        if  state.active.folder == item {
            
            processingState = DataReducer.deactivateFolderUsing(state)
        }
        
        let list = DataReducer.deleteFolderItem(rootItem: item,
                                                using: processingState.folders.items)
        let folders = FoldersData(items: list)
        
        result = DataState(processingState,
                           folders: folders)
        
    case .appendRootFolder(let url):
        
        let list = DataReducer.addFolderItem(with: url,
                                             using: state.folders.items)
        let folders = FoldersData(items: list)
        
        result = DataState(state,
                           folders: folders)
        
    case .selectGalleryItems(let items):
        
        let selectedItems = state.active.galleryItems.union(items)
        
        result = DataReducer.updateState(state,
                                         usingSelectedGalleryItems: selectedItems)
        
    case .deselectGalleryItems(let items):
        
        let selectedItems = state.active.galleryItems.subtracting(items)
        
        result = DataReducer.updateState(state,
                                         usingSelectedGalleryItems: selectedItems)
        
    case .updateImageTypes(let types):
        
        let imageFile = ImageFileSettingsData(availableTypes: types)
        let settings = SettingsData(imageFile: imageFile)
        result = DataState(state,
                           settings: settings)
        
    }
    
    if (result.settings !== state.settings) {
        
        DataReducer.store(settings: result.settings)
    }
    
    print("got state: \(result)")
    
    return result
}

class DataReducer {
    
    static func initialSettingsData() -> SettingsData {
        
        var settingsStorage: SettingsStorage? = nil
        
        let realm = try! Realm()
        settingsStorage = realm.objects(SettingsStorage.self).first
        
        guard let validStorage = settingsStorage else {
            
            return SettingsData()
        }
        
        let result = SettingsData(using: validStorage)
        return result
    }
    
    //MARK: - update state -
    
    static func deactivateFolderUsing(_ state: DataState) -> DataState {
        
        state.active.folder?.denyAccess()
        
        let result = DataState(state,
                               gallery: GalleryData([]),
                               active: ActiveData())
        return result
    }
    
    static func updateState(_ state: DataState,
                            usingSelectedGalleryItems selectedItems: Set<GalleryItem>) -> DataState {
        
        let active = ActiveData(folder: state.active.folder,
                                galleryItems: selectedItems)
        
        let result = DataState(state,
                               active: active)
        
        return result
    }
    
    //MARK: - store -
    
    static func store(settings: SettingsData) {
        
        let realm = try! Realm()
        
        let settingsStorage = realm.objects(SettingsStorage.self).first
        
        let validStorage = settingsStorage ?? SettingsStorage()
       
        try! realm.write {
            validStorage.update(using: settings)
            realm.add(validStorage)
        }
    }
    
    //MARK: - load save text file -
    
    static func loadText(fromFile fileName: String) -> String? {
        
        guard fileName.count > 0 else {
            return nil
        }
        
        let settings = Settings.program.settingsFolder
        
        let file = settings.appendingPathComponent(fileName)
        
        guard let result = try? String(contentsOf: file) else {
            return nil
        }
        
        return result
    }
    
    static func saveText(_ text: String, toFile fileName: String) {
        
        guard fileName.count > 0 else {
            return
        }
        
        let settings = Settings.program.settingsFolder
        
        FileManager.default.ensureDirectoryExists(at: settings)
        
        let file = settings.appendingPathComponent(fileName)
        
        do {
            try text.write(to: file,
                            atomically: true,
                            encoding: String.Encoding.utf8)
        } catch let error {
            
            print("Failed to save text to file \(file) error: \(error)")
        }
        
    }

    //MARK: - folders -
    
    static func isFolderAvailable(fileURL: URL) -> Bool {
        
        let values = try? fileURL.resourceValues(forKeys: [.isDirectoryKey])
        
        guard let isDirectory = values?.isDirectory,
            isDirectory == true else {
                return false
        }
        
        guard fileURL.pathExtension.lowercased() != "app" else {
            return false
        }
        
        return true
        
    }
    
    static func addFolderItem(with url: URL, using folderItems: [FolderItem]) -> [FolderItem] {
        
        let item = FolderItem.using(url)
        
        var result = folderItems
        result.append(item)
        
        let realm = try! Realm()
        try! realm.write {
            
            item.realmBacked = true
            realm.add(item)
        }
        
        result.sort{ FolderItem.compareItems($0, $1) == .orderedAscending }
        
        return result
        
    }
    
    static func deleteFolderItem(rootItem itemToDelete: FolderItem, using folderItems: [FolderItem]) -> [FolderItem] {
        
        let result = folderItems.filter { $0 !== itemToDelete }
        
        guard itemToDelete.realmBacked else {
            
            return result
        }
        
        let realm = try! Realm()
        try! realm.write {
            realm.delete(itemToDelete)
        }
        
        return result
    }
    
    //MARK: - gallery -
    
    static func isImageAvailable(fileURL: URL) -> Bool {
        
        let availableImageExtensions = dataStore.observable.value.settings.imageFile.availableExtensions
        let result = availableImageExtensions.contains(fileURL.pathExtension.lowercased())
        return result
    }
    
    static func loadGalleryItems(from folder: FolderItem?) -> Set<GalleryItem> {

        var result: Set<GalleryItem> = Set<GalleryItem>()

        guard let folder = folder else {
            return result
        }

        let enumerator = FileManager.default
            .enumerator(at: folder.getUrl(),
                        includingPropertiesForKeys: nil,
                        options: [FileManager.DirectoryEnumerationOptions.skipsHiddenFiles,
                                  FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants,
                                  FileManager.DirectoryEnumerationOptions.skipsPackageDescendants])

        guard let subitems = enumerator else {
            return result
        }
        
        for url in subitems {
            guard let url = url as? URL,
                  DataReducer.isImageAvailable(fileURL: url) else {
                continue
            }

            let item = GalleryItem(url: url,
                                   folder: folder)

            result.insert(item)
        }

        return result
    }
}


