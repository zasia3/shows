//
//  ImagesLoaderTest.swift
//  DataLoaderTests
//
//  Created by Joanna Zatorska on 26/04/2021.
//

import XCTest
@testable import DataLoader

class ImagesLoaderTest: XCTestCase {

    var sut: ImagesLoader!
    fileprivate var sessionMock: URLSessionMock!
    fileprivate var imagesHandlerMock: ImageFilesHandlerMock!
    
    override func setUpWithError() throws {
        sessionMock = URLSessionMock()
        imagesHandlerMock = ImageFilesHandlerMock()
        sut = ImagesLoader(session: sessionMock, imagesFileHandler: imagesHandlerMock, downloadDirectory: URL(string: "file://testDir"))
        sessionMock.downloadDelegate = sut
    }

    func testImageDownload() throws {
        let expect = expectation(description: #function)
        let testUrl = URL(string: "https://google.com")!
        
        var downloadedUrl: URL?
        sut.downloadFromUrl(testUrl) { progress in
            switch progress {
            case .downloaded(let url):
                downloadedUrl = url
            default:
                break
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 2) { (error) in
            XCTAssertNotNil(downloadedUrl)
        }
    }
}

private class ImageFilesHandlerMock: ImageFileHandlerProtocol {
    func fileExistsAtPathURL(_ pathURL: URL) -> Bool {
        return false
    }
    func fileExistsAtPath(_ path: String) -> Bool {
        return false
    }
    func replaceItemAtURL(_ destinationUrl: URL, withItemAtURL sourceUrl: URL) -> Error? {
        return nil
    }
    func moveItemAtURL(_ sourceUrl: URL, toURL destinationUrl: URL) -> Error? {
        return nil
    }
}

private class URLSessionDataTaskMock: URLSessionDownloadTask {
    
    var delegate: URLSessionDownloadDelegate?
    let session: URLSession
    var url: URL
    
    init(session: URLSession, url: URL) {
        self.session = session
        self.url = url
    }
    
    override func resume() {
        delegate?.urlSession(session, downloadTask: self, didFinishDownloadingTo: url)
    }
}

private class URLSessionMock: URLSession {
    var downloadDelegate: URLSessionDownloadDelegate?
    var url = URL(string: "file://testDir")!
    
    override func downloadTask(with url: URL) -> URLSessionDownloadTask {
        let task = URLSessionDataTaskMock(session: self, url: url)
        task.delegate = downloadDelegate
        return task
    }
}
