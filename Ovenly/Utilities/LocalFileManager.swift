//
//  LocalFileManager.swift
//  Ovenly
//
//  Created by Jessica Parsons on 2/11/25.
//
import Foundation
import SwiftUI

actor LocalFileManager {
    
    static let instance = LocalFileManager()
    internal let memoryCache = NSCache<NSString, NSURL>()
    let folderName = "Ovenly_Images"
    
    private init() {
        Task {
            await createFolderIfNeeded()
        }
    }
    
    //Create app specific folder so we can find our cached images easily
    func createFolderIfNeeded() {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appending(path: folderName).path else {
            return
        }
        
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                print("Success creating folder")
            } catch let error {
                print("Error creating folder: \(error)")
            }
        }
    }
    
    //Check if image is cached
    func getCachedImageURL(for image: String) -> URL? {
        if let cachedURL = memoryCache.object(forKey: image as NSString) {
            print("Using the in-memory cached image: \(image)")
            return cachedURL as URL
        }
        
        if let diskURL = getImage(name: image) as URL? {
            memoryCache.setObject(diskURL as NSURL, forKey: image as NSString)
            print("Using the disk cached image: \(image)")
            return diskURL
        }
        print("Error retreiving diskURL")
        return nil
    }
    
    //download and save image to temporary cache
    func downloadAndSaveImageToCache(from urlString: String, image: String) async throws -> URL? {
        guard let url = URL(string: urlString) else { return nil }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let path = saveImageToDisk(image: data, name: image) else { return nil }
        
        memoryCache.setObject(path as NSURL, forKey: image as NSString)
        
        print("Image downloaded and saved: \(path)")
        return path
    }
    
    //Save images to the file manager
    func saveImageToDisk(image: Data, name: String) -> URL? {
        
        guard
            //let data = image.jpegData(compressionQuality: 0.5),
            let path = getPathForImage(name: name) else {
            print("Error getting data")
            return nil
        }
        
        do {
            try image.write(to: path)
            print("Success saving image to disk")
            return path
        } catch let error {
            print("Error saving image to disk: \(error)")
            return nil
        }
    }
    
    //Load image from file manager
    func getImage(name: String) -> URL? {
        
        guard let path = getPathForImage(name: name),
              FileManager.default.fileExists(atPath: path.path) else {
            print("Error getting path")
            return nil
        }
        
        return path
        
    }
    
    //Get folder path for image
    private func getPathForImage(name: String) -> URL? {
        guard
            let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appending(path: folderName).appending(path: "\(name).jpg") else {
                print("Error getting path")
                return nil
        }
        return path
    }
    
}
