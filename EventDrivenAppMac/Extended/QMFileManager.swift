//
//  QMFileManager.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 3/20/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation


extension FileManager {
    
    // MARK: existence
    
    func exists(at url: URL?, isDirectory: inout Bool) -> Bool {
        
        guard let path = url?.path else {
            
            return false
        }
        
        var isDirectoryObjC = ObjCBool(false)
        let result = fileExists(atPath: path,
                                isDirectory: &isDirectoryObjC)
        
        isDirectory = isDirectoryObjC.boolValue
        return result
    }
    
    func fileExists(at url: URL?) -> Bool {
        
        var directory = true
        let existed = exists(at: url, isDirectory: &directory)
        
        let result = existed && directory == false
        return result
    }
    
    func directoryExists(at url: URL?) -> Bool {
        
        var directory = false
        let existed = exists(at: url, isDirectory: &directory)

        let result = existed && directory
        return result
    }
    
    func ensureDirectoryExists(at url: URL?) {
        
        guard let directory = url else {
            
            return
        }
        
        guard directoryExists(at: directory) == false  else {
            
            return
        }
        
        do {
            try createDirectory(atPath: directory.path,
                                withIntermediateDirectories: true,
                                attributes: nil)
            
        } catch let error {
            
            print("failed create a backup directory error: \(error)")
        }
    }
    
    //MARK: versionning copy
    
    func copyVersion(of fileUrl: URL, toDirectory directoryUrl: URL?) {
        
        guard let directory = directoryUrl else {
            
            return
        }
        
        
        if let copyUrl = versionUrl(using: fileUrl, targetDirectory: directory) {
            
            do {
                try copyItem(at: fileUrl,
                             to: copyUrl)
                
            } catch let error {
                
                print("failed make an image copy before apply changes: \(error)")
            }
        }
    }
    
    func indexedUrl(using fileUrl: URL,
                    newFileName fileName: String?,
                    index: String) -> URL {
        
        let fileTitle = fileName ?? fileUrl.deletingPathExtension().lastPathComponent
        let fileExtension = fileUrl.pathExtension
        let filePathExtension = "\(fileTitle)\(index).\(fileExtension)"
        let result = fileUrl.deletingLastPathComponent().appendingPathComponent(filePathExtension)
        
        return result
    }
    
    func versionUrl(using fileUrl: URL, targetDirectory directoryURL: URL) -> URL? {
        
        let majorUrl = directoryURL.appendingPathComponent(fileUrl.lastPathComponent)
        
        guard fileExists(at: majorUrl) else {
            
            return majorUrl
        }
        
        var result: URL? = nil
        var version = 1
        
        let fileTitle = fileUrl.deletingPathExtension().lastPathComponent
        let fileExtension = fileUrl.pathExtension
        
        while result == nil, version < 1000000 {
            
            version = version + 1
            
            let filePathExtension = "\(fileTitle)-\(version).\(fileExtension)"
            let resultCandidate = directoryURL.appendingPathComponent(filePathExtension)
            
            if fileExists(at: resultCandidate) == false {
                
                result = resultCandidate
            }
        }
        
        return result
    }
}



