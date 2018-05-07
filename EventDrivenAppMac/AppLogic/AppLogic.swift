//
//  StateHolder.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 1/15/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import ReactiveReSwift
import RxSwift
import RealmSwift
import AVFoundation


let integration = Integration()

// The global application stores, which is responsible for managing the appliction state.

let dataStore = Store(reducer: dataReducer,
                      observable: Variable(DataState(folders: FoldersData.initial(),
                                                     gallery: GalleryData(),
                                                     active: ActiveData(),
                                                     settings: DataReducer.initialSettingsData())))

let interfaceStore = Store(reducer: interfaceReducer,
                           observable: Variable(InterfaceState(currentController: NSWindowController(),
                                                               mainWindow: WindowInterface(),
                                                               folders: FoldersInterface(),
                                                               gallery: GalleryInterface())))

let interfaceAction = Variable(InterfaceStatelessAction.initial)


let soundPlayer: AVAudioPlayer? = {
    
    guard let audioFileUrl = Bundle.main.url(forResource: "Next",
                                             withExtension: "aif") else {
        return nil
    }

    let result = try? AVAudioPlayer(contentsOf: audioFileUrl)
    result?.prepareToPlay()
    return result
}()


class User {
    
    static func did(_ action: UserAction) {
        
        Event.user(action: action)
        
        switch action {
            
        case .openUserManual:
            
            let url = Settings.program.userManualUrl
            interfaceStore.dispatch(InterfaceAction.app(action: .openUrl(url: url)))
            
        case .openTutorial:
            
            let url = Settings.program.tutorialUrl
            interfaceStore.dispatch(InterfaceAction.app(action: .openUrl(url: url)))
            
        case .showFeedbackDialog:
            
            // show feedback
            break
            
        case .checkForUpdates:
            
            // check for updates
            break

        case .toolbar(let toolbarAction):
            
            switch toolbarAction {
                
            case .clicked(let button):
                
                let windowState = interfaceStore.observable.value.mainWindow
                interfaceStore.dispatch(InterfaceReducer.interfaceAction(for: button,
                                                                         activeScene: windowState.activeScene))
            }
            
        case .folder(let folderAction):
            
            switch folderAction {
            case .appendRoot(let url):
                dataStore.dispatch(DataAction.appendRootFolder(usingUrl: url))
            case .deleteRoot(let item):
                dataStore.dispatch(DataAction.deleteRootFolder(item: item))
            case .activate(let item):
                dataStore.dispatch(DataAction.deactivateFolder)
                dataStore.dispatch(DataAction.activateFolder(item: item))
            case .foldAll:
                dataStore.dispatch(DataAction.deactivateFolder)
            }
            
        case .gallery(let galleryAction):
            
            switch galleryAction {
                
            case .activate(let items):
                
                dataStore.dispatch(DataAction.selectGalleryItems(items: items))
                
            case .deactivate(let items):
                
                dataStore.dispatch(DataAction.deselectGalleryItems(items: items))
                
            case .didChangeGridSlider(let value):
                
                interfaceStore.dispatch(InterfaceAction.gallery(action: .changeGridItem(size: value)))
                
            case .showItemInFinder(let item):
                
                interfaceStore.dispatch(InterfaceAction.app(action: .showInFinder(url: item.imageUrl)))
            
            case .openItemInDefaultApp(let item):
                
                interfaceStore.dispatch(InterfaceAction.app(action: .openUrl(url: item.imageUrl)))
                
            case .openPreview:
                
                interfaceStore.dispatch(InterfaceAction.app(action: .openPreview))
            
            }
        
        case .settings(let settingsAction):
            
            switch settingsAction {
                
            case .finishEditing:
                
                interfaceStore.dispatch(InterfaceAction.updateScreen(forScene: .gallery))
                
            case .updateImageTypes(let types):
                
                dataStore.dispatch(DataAction.updateImageTypes(types: types))
                
                guard let activeFolder = dataStore.observable.value.active.folder else {
                    
                    break
                }
                
                dataStore.dispatch(DataAction.activateFolder(item: activeFolder))
                
            case .showBackupsFolderInFinder:
                
                let folder = Settings.program.backupFolder
                NSWorkspace.shared.activateFileViewerSelecting([folder])
            }
            
        case .preview(let previewAction):
            
            switch previewAction {
                
            case .close:
                
                interfaceStore.dispatch(InterfaceAction.app(action: .closePreview))
                
            case .lastViewed(let item):
                
                let activeItems = dataStore.observable.value.active.galleryItems
                
                guard activeItems.count <= 1 else {
                    
                    break
                }
                
                let items: Set<GalleryItem> = [item]
                dataStore.dispatch(DataAction.deselectGalleryItems(items: activeItems))
                dataStore.dispatch(DataAction.selectGalleryItems(items: items))
            }
        }
    }
}


