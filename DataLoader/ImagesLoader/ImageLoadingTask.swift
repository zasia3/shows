//
//  ImageLoadingTask.swift
//  DataLoader
//
//  Created by Joanna Zatorska on 25/04/2021.
//

import Foundation

class Task {
    var id: Int { return sessionTask.taskIdentifier }
    let pathURL: URL
    let sessionTask: URLSessionDownloadTask
    var progress: Progress = .ready {
        willSet {
            if case .cancelled = newValue {
                sessionTask.cancel()
            }
        }
        didSet {
            switch oldValue {
                case .ready:
                    for completion in completions { completion(progress) }
                case .downloaded, .cancelled, .failed:
                    progress = oldValue
            }
        }
    }
    var completions = [ImagesLoader.Completion]()

    init(pathURL: URL, sessionTask: URLSessionDownloadTask) {
        self.pathURL = pathURL
        self.sessionTask = sessionTask
    }
}

class Tasks {
    var ids = [Int: Task]()
    var paths = [URL: Task]()

    func add(_ task: Task) {
        ids[task.id] = task
        paths[task.pathURL as URL] = task
    }

    func remove(_ task: Task) {
        ids.removeValue(forKey: task.id)
        paths.removeValue(forKey: task.pathURL as URL)
    }
}

extension Tasks : Sequence {
    func makeIterator() -> DictionaryIterator<Int, Task> {
        return ids.makeIterator()
    }

    subscript(taskID: Int) -> Task? {
        set {
            ids[taskID] = newValue
        }
        get {
            return ids[taskID]
        }
    }

    subscript(pathURL: URL) -> Task? {
        set {
            paths[pathURL] = newValue
        }
        get {
            return paths[pathURL]
        }
    }
}
