//
//  ToolbarActions.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 12/14/17.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import ReactiveReSwift
import LocationInfo


enum InterfaceStatelessAction {
    
    case initial
    case clearLoacationsSearchField
}

enum ToolbarButton {
    
    case sidebar, settings
}

//MARK: - interface action -

enum FoldersInterfaceAction: Action {
    
}

enum GalleryInterfaceAction: Action {
    
    case changeGridItem(size: Int)
}

enum AppAction: Action {
    
    case showInFinder(url: URL)
    case openUrl(url: URL)
    case openPreview
    case closePreview
}

enum LocationSearchInterfaceAction: Action {
    
}

enum InspectorInterfaceAction: Action {

}

enum InterfaceAction: Action {

    case displaySplashScreen
    case displayMainScreen
    case updateScreen(forScene: UIScene)
    case toggleSidebar
    case gallery(action: GalleryInterfaceAction)
    case app(action: AppAction)
}

//MARK: - user action -

enum ToolbarUserAction: Action {
    
    case clicked(button: ToolbarButton)
}

enum FolderUserAction: Action {
    
    case activate(folder: FolderItem)
    case foldAll
    case deleteRoot(folder: FolderItem)
    case appendRoot(folderURL: URL)
}

enum GallerUserAction: Action {
    
    case activate(galleryItems: Set<GalleryItem>)
    case deactivate(galleryItems: Set<GalleryItem>)
    case didChangeGridSlider(value: Int)
    case showItemInFinder(item: GalleryItem)
    case openItemInDefaultApp(item: GalleryItem)
    case openPreview
}

enum SettingsUserAction: Action {
    
    case finishEditing
    case updateImageTypes(types: [ImageType])
    case showBackupsFolderInFinder
}

enum PreviewUserAction: Action {
    
    case close
    case lastViewed(item: GalleryItem)
}

enum UserAction: Action {
    
    case openUserManual
    case openTutorial
    case showFeedbackDialog
    case checkForUpdates
    
    case toolbar(action: ToolbarUserAction)
    case gallery(action: GallerUserAction)
    case folder(action: FolderUserAction)
    case settings(action: SettingsUserAction)
    case preview(action: PreviewUserAction)
}

//MARK: - business logic action -

enum DataAction: Action {
    
    case activateFolder(item: FolderItem)
    case deactivateFolder
    case deleteRootFolder(item: FolderItem)
    case appendRootFolder(usingUrl: URL)
    
    case selectGalleryItems(items: Set<GalleryItem>)
    case deselectGalleryItems(items: Set<GalleryItem>)

    case updateImageTypes(types: [ImageType])
}
