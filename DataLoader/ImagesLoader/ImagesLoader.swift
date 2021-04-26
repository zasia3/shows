//
//  ImagesLoader.swift
//  DataLoader
//
//  Created by Joanna Zatorska on 25/04/2021.
//

import UIKit

public protocol ImagesLoaderProtocol {
    func downloadFromUrl(_ url: URL, completion: @escaping ImagesLoader.Completion)
    func cancelDownloading()
}

public enum Progress {
    case ready
    case downloaded(URL)
    case cancelled
    case failed(Error?)
}

public class ImagesLoader: NSObject, ImagesLoaderProtocol {
    
    public typealias Completion = ((Progress) -> Void)
    
    private lazy var defaultSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "ImageLoadingSession")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
    }()
    
    private let privateSession: URLSession?
    private var session: URLSession {
        privateSession ?? defaultSession
    }
    
    private let downloadDirectory: URL?
    private let imagesFileHandler: ImageFileHandlerProtocol
    private var tasks = Tasks()
    
    public init(session: URLSession? = nil, imagesFileHandler: ImageFileHandlerProtocol? = nil, downloadDirectory: URL?) {
        self.imagesFileHandler = imagesFileHandler ?? ImageFileHandler()
        self.downloadDirectory = downloadDirectory
        self.privateSession = session
    }
    
    public func downloadFromUrl(_ url: URL, completion: @escaping Completion) {
        guard let pathUrl = downloadDirectory?.appendingPathComponent("\(UUID().uuidString).jpg") else {
            return
        }
        if let task = tasks[pathUrl] {
            task.completions.append(completion)
            return
        }
        
        let sessionTask = session.downloadTask(with: url)
         
        let task = Task(pathURL: pathUrl, sessionTask: sessionTask)
        task.completions.append(completion)
        tasks.add(task)

        sessionTask.resume()
    }
    public func cancelDownloading() {
        tasks.forEach { (key, task) in
            task.progress = .cancelled
        }
        tasks = Tasks()
    }
}

extension ImagesLoader: URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let task = tasks[downloadTask.taskIdentifier] else { return }
        
        var fileError: Error?
        if imagesFileHandler.fileExistsAtPath(task.pathURL.path) {
            fileError = imagesFileHandler.replaceItemAtURL(task.pathURL, withItemAtURL: location)
        } else {
            fileError = imagesFileHandler.moveItemAtURL(location, toURL: task.pathURL)
        }

        if let error = fileError {
            task.progress = .failed(error)
        } else {
            task.progress = .downloaded(task.pathURL)
        }
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let task = tasks[task.taskIdentifier] else { return }

        tasks.remove(task)

        guard let error = error else { return }

        task.progress = .failed(error)
    }
}
