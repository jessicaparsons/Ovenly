//
//  LocalFileManagerTests.swift
//  OvenlyTests
//
//  Created by Jessica Parsons on 2/11/25.
//

import XCTest
@testable import Ovenly

final class LocalFileManagerTests: XCTestCase {
    
    var localFileManager: LocalFileManager!
    let testImageName = "testImage"
    let testImageData = UIImage(systemName: "birthday.cake")!.jpegData(compressionQuality: 0.5)!
    let testURLString = "https://d3jbb8n5wk0qxi.cloudfront.net/photos/27c50c00-148e-4d2a-abb7-942182bb6d94/large.jpg"
    
    override func setUpWithError() throws {
        super.setUp()
        localFileManager = LocalFileManager.instance
        clearTestFiles()
        
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
        clearTestFiles()
        localFileManager = nil
    }
    
    func testCreateFolderIfNeeded() {
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appending(path: localFileManager.folderName).path
        
        XCTAssertTrue(FileManager.default.fileExists(atPath: path!))
    }
    
    func testGetCachedImageURL_IsInMemory() {
        let testURL = URL(fileURLWithPath: NSTemporaryDirectory()).appending(path: "\(testImageName).jpg")
        
        localFileManager.memoryCache.setObject(testURL as NSURL, forKey: testImageName as NSString)
        
        let cachedURL = localFileManager.getCachedImageURL(for: testImageName)
        XCTAssertEqual(cachedURL, testURL)
    }
    
    func testGetCachedImageURL_DiskCache() {
        let savedURL = localFileManager.saveImageToDisk(image: testImageData, name: testImageName)
        XCTAssertNotNil(savedURL)
        
        let cachedURL = localFileManager.getCachedImageURL(for: testImageName)
        XCTAssertEqual(cachedURL, savedURL)
    }
    
    func testGetCachedImageURL_NoCache() {
        let cachedURL = localFileManager.getCachedImageURL(for: testImageName + "NonExistent")
        XCTAssertNil(cachedURL)
    }
    
    func testSaveImageToDisk() {
        let savedDiskURL = localFileManager.saveImageToDisk(image: testImageData, name: testImageName)
        XCTAssertNotNil(savedDiskURL)
        XCTAssertTrue(FileManager.default.fileExists(atPath: savedDiskURL!.path))
    }
    
    func testGetImage() {
        let savedDiskURL = localFileManager.saveImageToDisk(image: testImageData, name: testImageName)
        XCTAssertNotNil(savedDiskURL)
        
        let loadedURL = localFileManager.getImage(name: testImageName)
        XCTAssertEqual(loadedURL, savedDiskURL)
    }
    
    func testGetImage_NotFound() {
        let loadedURL = localFileManager.getImage(name: testImageName + "NonExistent")
        XCTAssertNil(loadedURL)
    }
    
    // Helper function to delete test files
    private func clearTestFiles() {
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appending(path: localFileManager.folderName)
        
        if let directoryURL = path {
            do {
                let fileURLs = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)
                for fileURL in fileURLs {
                    try FileManager.default.removeItem(at: fileURL)
                }
            } catch {
                print("Error clearing test files: \(error)")
            }
        }
    }
    
}
