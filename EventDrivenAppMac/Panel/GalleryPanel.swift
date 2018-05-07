//
//  GalleryPanel.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 1/11/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Cocoa
import RxSwift
import QuickLook
import Quartz

enum GalleryItemMenuTag: Int {
    
    case open
    case showInFinder
}

class GalleryPanel: NSViewController {
    
    private let disposeBag = DisposeBag()
    
    private var items: [GalleryItem] = []
    private var previewItems: [GalleryItem] = []
    private var activeData: ActiveData = ActiveData()
    private var previewItemsBlock: GalleryItemsBlock = { [] }
    
    private var interface: GalleryInterface? = nil
    private var keyListenerHandle: Any? = nil
    
    @IBOutlet weak var descriptionTitle: NSTextField!
    @IBOutlet weak var sizeSlider: NSSlider!
    @IBOutlet weak var imagesCollection: ItemMenuCollectionView!
    
    @IBAction func sliderDidSlide(_ sender: NSSlider) {
        let value = sender.integerValue as Int
        User.did(.gallery(action: .didChangeGridSlider(value: value)))
    }
    
    @objc private func menuItemDidSelect(_ sender: NSMenuItem) {
        
        guard let item = sender.representedObject as? GalleryItem else {
            return
        }
        
        guard let tag = GalleryItemMenuTag(rawValue: sender.tag) else {
            
            print("Failed to determinate user action in gallery item menu. Unsupported tag found")
            return
        }
        
        switch tag {
            
            case .open:
            
                User.did(.gallery(action: .openItemInDefaultApp(item: item)))
            
            case .showInFinder:
            
                User.did(.gallery(action: .showItemInFinder(item: item)))

        }
    }
    
    //MARK: - life cycle -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let keyCaptureView = view as? KeyCaptureView {
            
            keyCaptureView.delegate = self
        }
        
        imagesCollection.register(GalleryViewItem.nib,
                                  forItemWithIdentifier: GalleryViewItem.reuseId)
        sizeSlider.altIncrementValue = 10

            
        let dataDisposable = dataStore.observable.asObservable().subscribe(onNext: { [weak self] state in
            
            self?.updateGalleryItems(state.displayedGalleryItems)
            self?.updateActiveData(state.active)
            
            self?.previewItemsBlock = state.previewGalleryItemsBlock
            
            self?.updateSelectedItems(count: state.active.galleryItems.count)
        })
        
        let interfaceDisposable = interfaceStore.observable.asObservable().subscribe(onNext: { [weak self] state in
            
            guard let strongSelf = self else {
                return
            }
            
            guard strongSelf.interface !== state.gallery else {
                return
            }
            
            strongSelf.interface = state.gallery
            
            let itemSize = NSSize(width: state.gallery.gridItemSize,
                                  height: state.gallery.gridItemSize)

            
            self?.imagesCollection.maxItemSize = itemSize
            self?.imagesCollection.minItemSize = itemSize
            self?.sizeSlider.integerValue = state.gallery.gridItemSize
        })
        
        disposeBag.insert(dataDisposable)
        disposeBag.insert(interfaceDisposable)
    }
    
    //MARK: - logic -
    
    private func updateGalleryItems(_ incomingItems: [GalleryItem]) {
        
        guard items != incomingItems else {
            
            return
        }
        
        items = incomingItems
        
        DispatchQueue.main.async { [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.imagesCollection.reloadData()
            strongSelf.updateSelection(using: strongSelf.activeData.galleryItems)
        }
    }
    
    private func updateActiveData(_ incomingData: ActiveData) {
        
        guard activeData !== incomingData else {
            
            return
        }
        
        guard activeData.galleryItems != incomingData.galleryItems else {
            
            activeData = incomingData
            return
        }
        
        activeData = incomingData
        
        DispatchQueue.main.async { [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.updateSelection(using: strongSelf.activeData.galleryItems)
        }
    }
    
    private func updateSelection(using slelectedItems: Set<GalleryItem>) {
        
        let selected = indexPathes(for: slelectedItems)
        imagesCollection.selectionIndexPaths = selected
    }
    
    private func acceptKeyDown(with event: NSEvent) -> Bool {
         
        let modifiers: NSEvent.ModifierFlags = [.command, .control, .option]

        guard event.modifierFlags.intersection(modifiers).rawValue == 0 else {

            return false
        }

        guard event.charactersIgnoringModifiers == " " else {

            return false
        }
        
        User.did(.gallery(action: .openPreview))
        
        return true
    }
    
    private func updateSelectedItems(count: Int) {
        
        let text = String.localizedStringWithFormat(
            NSLocalizedString("%d images selected", comment: ""), count)
        descriptionTitle.stringValue = text
    }
    
    func indexPathes(for items: Set<GalleryItem>) -> Set<IndexPath> {
        
        var result: Set<IndexPath> = Set<IndexPath>()
        
        for item in items {
            let path = indexPath(for: item)
            
            guard path != nil else {
                continue
            }
            
            result.insert(path!)
        }
        
        return result
        
    }
    
    func indexPath(for item: GalleryItem) -> IndexPath? {
        
        let index = items.index(of: item)
        
        guard let validIndex = index else {
            return nil
        }
        
        let indexes = [0, validIndex]
        let result = IndexPath(indexes: indexes)
        
        return result
    }
    
    func itemsUsing(_ indexPathes: Set<IndexPath>) -> Set<GalleryItem> {
        
        var result: Set<GalleryItem> = Set<GalleryItem>()
        
        for indexPath in indexPathes {
            let item = itemUsing(indexPath)
            
            guard item != nil else {
                continue
            }
            
            result.insert(item!)
        }
        
        return result
    }
    
    func itemUsing(_ indexPath: IndexPath?) -> GalleryItem? {
        
        guard indexPath != nil,
            indexPath![1] < items.count else {
                return nil
        }
        
        let index = indexPath![1]
        
        let result = items[index]
        return result
    }
}

extension GalleryPanel: KeyCaptureViewDelegate {
    
    // So key down event
    // The Window send it to collection view, that has overrided by us keyDown(with: ) method and
    // pass single key event up to next responder all and again the way up to the window
    // when it returns to the window, it send event using this time
    // performKeyEquivalent(with:) method
    // down to view hierarchy where sits the KeyCaptureView and catch it
    
    // here the code
    
    func keyCaptureView(_ view: KeyCaptureView,
                        performKeyEquivalentWith event: NSEvent) -> Bool {
        
        guard imagesCollection.isFirstResponder else {
            
            return false;
        }
        
        let result = acceptKeyDown(with: event)
        return result
    }
}

extension GalleryPanel: NSCollectionViewDataSource, ItemMenuCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView,
                        menu: NSMenu?,
                        at indexPath: IndexPath?) -> NSMenu? {
        
        guard collectionView.selectionIndexPaths.count < 2 else {
            
            return nil
        }
        
        let item = itemUsing(indexPath)
        
        let result = NSMenu()
        
        let openItem = NSMenuItem()
        openItem.title = NSLocalizedString("Open", comment: "")
        openItem.target = self
        openItem.action = #selector(GalleryPanel.menuItemDidSelect(_:))
        openItem.representedObject = item
        openItem.tag = GalleryItemMenuTag.open.rawValue
        
        result.addItem(openItem)
        
        let showItem = NSMenuItem()
        showItem.title = NSLocalizedString("Show in Finder", comment: "")
        showItem.target = self
        showItem.action = #selector(GalleryPanel.menuItemDidSelect(_:))
        showItem.representedObject = item
        showItem.tag = GalleryItemMenuTag.showInFinder.rawValue
        
        result.addItem(showItem)
    
        return result
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {

        return items.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let galleryViewItem = collectionView.makeItem(withIdentifier: GalleryViewItem.reuseId, for: indexPath)
        
        guard let result = galleryViewItem as? GalleryViewItem else {
            
            return NSCollectionViewItem()
        }
        
        result.noteReuse(with: indexPath)
        
        let item = itemUsing(indexPath)
        item?.updateRepresented(result.imageView)
        
        return result
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        
        let items = itemsUsing(indexPaths)
        User.did(.gallery(action: .activate(galleryItems: items)))
    }
    
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        
        let items = itemsUsing(indexPaths)
        User.did(.gallery(action: .deactivate(galleryItems: items)))
    }
}

extension GalleryPanel: QLPreviewPanelDataSource, QLPreviewPanelDelegate {

    func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
        
        return previewItems.count
    }
    
    func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem! {
        
        return previewItems[index].preview
    }

    func previewPanel(_ panel: QLPreviewPanel!, handle event: NSEvent!) -> Bool {
        
        let modifiers: NSEvent.ModifierFlags = [.command, .control, .option]
        
        guard event.modifierFlags.intersection(modifiers).rawValue == 0 else {
        
            return false
        }
        
        guard event.charactersIgnoringModifiers == " " else {
            
            return false
        }
        
        User.did(.preview(action: .close))
        
        return true
    }
    
    override func acceptsPreviewPanelControl(_ panel: QLPreviewPanel!) -> Bool {
        
        return true
    }


    override func beginPreviewPanelControl(_ panel: QLPreviewPanel!) {
        
        panel.dataSource = self
        panel.delegate = self
        
        previewItems = previewItemsBlock()
    }
    
    override func endPreviewPanelControl(_ panel: QLPreviewPanel!) {

        let item = previewItems[panel.currentPreviewItemIndex]
        
        User.did(.preview(action: .lastViewed(item: item)))
        
        previewItems = []
        panel.dataSource = nil
        panel.delegate = nil
    }
}

