//
//  ImageFileHandler.swift
//  DataLoader
//
//  Created by Joanna Zatorska on 25/04/2021.
//

import Foundation

public protocol ImageFileHandlerProtocol {
    func fileExistsAtPathURL(_ pathURL: URL) -> Bool
    func fileExistsAtPath(_ path: String) -> Bool
    func replaceItemAtURL(_ destinationUrl: URL, withItemAtURL sourceUrl: URL) -> Error?
    func moveItemAtURL(_ sourceUrl: URL, toURL destinationUrl: URL) -> Error?
}
class ImageFileHandler: ImageFileHandlerProtocol {
    func fileExistsAtPathURL(_ pathURL: URL) -> Bool {
        return fileExistsAtPath(pathURL.path)
    }

    func fileExistsAtPath(_ path: String) -> Bool {
        let fileManager = Foundation.FileManager.default
        return fileManager.fileExists(atPath: path)
    }

    func replaceItemAtURL(_ destinationUrl: URL, withItemAtURL sourceUrl: URL) -> Error? {
        let fileManager = Foundation.FileManager.default
        do {
            try fileManager.replaceItem(at: destinationUrl, withItemAt: sourceUrl, backupItemName: nil, options: .usingNewMetadataOnly, resultingItemURL: nil)
            return nil
        } catch  {
            return error
        }
    }

    func moveItemAtURL(_ sourceUrl: URL, toURL destinationUrl: URL) -> Error? {
        let fileManager = Foundation.FileManager.default
        do {
            try fileManager.moveItem(at: sourceUrl, to: destinationUrl)
            return nil
        } catch {
            return error
        }
    }
}
