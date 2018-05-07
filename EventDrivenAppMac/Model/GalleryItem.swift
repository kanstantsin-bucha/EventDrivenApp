//
//  GalleryItem.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 1/15/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation
import RealmSwift
import BuchaSwift
import QuickLook
import Quartz


enum GalleryItemError: Error {
    case failedImageSource(desc: String)
}

class GalleryItem {
    
    private (set) var dateLastUpdated = Date()
    
    private static var thumbnailQueue: OperationQueue = {
        
        let queue = OperationQueue()
        queue.name = "GalleryItemThumbnailQueue"
        return queue
    }()
    
    lazy var preview: GalleryItemPreview = {
       
        return GalleryItemPreview(url: imageUrl)
    }()
    
    private lazy var imageSource: CGImageSource? = {
        
        let result = CGImageSourceCreateWithURL(self.imageUrl.absoluteURL as CFURL, nil)
        if let imageSource = result {
            guard CGImageSourceGetType(imageSource) != nil else {
                return nil
            }
        }
        
        return result
    }()
    
    var thumbnail: NSImage?
    
    var image: NSImage?
    var imageUrl: URL
    var folder: FolderItem
    
    weak var representedImage: NSImageView?

    
    init(url: URL, folder: FolderItem) {
        
        self.imageUrl = url
        self.folder = folder
    }
    
    //MARK: - interface -
    
    func updateRepresented(_ imageView: NSImageView?) {
        
        representedImage = imageView
        
        thumbnailWithCompletion { [weak self] (thumbnail, error) in
            guard let represented = self?.representedImage,
                  error == nil else {
                print(String(describing: error))
                return
            }
            
            represented.image = thumbnail
        }
    }
    
    func forgetRepresented() {
        representedImage = nil
    }
    
    static func compareItems(_ lhs: GalleryItem, _ rhs: GalleryItem) -> ComparisonResult {
        
        let left = lhs.imageUrl.absoluteString
        let right = rhs.imageUrl.absoluteString
        let result = left.localizedStandardCompare(right)
        
        return result
    }
    
    //MARK: - logic -
    
    func thumbnailWithCompletion(_ completion: @escaping DataErrorCompletion<NSImage?, GalleryItemError>) {
        
        if let thumbnail = thumbnail {
            completion(thumbnail, nil)
            return
        }
        
        GalleryItem.thumbnailQueue.addOperation { [weak self] in
            guard let imageSource = self?.imageSource else {
                OperationQueue.main.addOperation {
                    completion(nil, GalleryItemError.failedImageSource(desc: "Image source is nil"))
                }
                return
            }
            
            let thumbnailOptions = [
                String(kCGImageSourceCreateThumbnailFromImageIfAbsent): true,
                String(kCGImageSourceThumbnailMaxPixelSize): Settings.gallery.thumbnailDimension
                ] as [String : Any]
            
            guard let thumbnailRef = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, thumbnailOptions as CFDictionary?) else {
                OperationQueue.main.addOperation {
                    completion(nil, GalleryItemError.failedImageSource(desc: "Image source failed to create thumbnail"))
                }
                return
            }
            
            let result = NSImage(cgImage: thumbnailRef,
                                 size: NSSize.zero)
            
            OperationQueue.main.addOperation {
                self?.thumbnail = result
                
                completion(result, nil)
            }
        }
    }
    
}

class GalleryItemPreview : NSObject, QLPreviewItem {
    
    let previewItemURL: URL
    
    init(url: URL) {
        self .previewItemURL = url
    }
    
}

extension GalleryItem: CustomStringConvertible {
    
    var description: String {
        
        let loadedDescription = thumbnail == nil ? "not loaded>"
                                                 : "image \(String(describing: image))>"
        let result = "<\(String(describing: type(of: self))):  \(imageUrl), \(loadedDescription)"
        return result
    }
    
}

extension GalleryItem: Hashable {
    
    public var hashValue: Int {
        return imageUrl.absoluteString.hashValue
    }
}

extension GalleryItem: Equatable, Comparable {
    
    public static func ==(lhs: GalleryItem, rhs: GalleryItem) -> Bool {
        let result =  GalleryItem.compareItems(lhs, rhs) == .orderedSame
        return result
    }
    
    public static func <(lhs: GalleryItem, rhs: GalleryItem) -> Bool {
        let result = GalleryItem.compareItems(lhs, rhs) == .orderedAscending
        return result
    }
    
    public static func <=(lhs: GalleryItem, rhs: GalleryItem) -> Bool {
        return lhs == rhs || lhs < rhs
    }

    public static func >=(lhs: GalleryItem, rhs: GalleryItem) -> Bool {
        return lhs == rhs || lhs > rhs
    }
    
    public static func >(lhs: GalleryItem, rhs: GalleryItem) -> Bool {
        let result =  GalleryItem.compareItems(lhs, rhs) == .orderedDescending
        return result
    }
}

