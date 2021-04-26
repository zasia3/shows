//
//  APITests.swift
//  APITests
//
//  Created by Joanna Zatorska on 26/04/2021.
//

import XCTest
@testable import API
import Models

class APITests: XCTestCase {
    
    var sut: API!
    fileprivate var sessionMock: URLSessionMock!
    
    override func setUpWithError() throws {
        sessionMock = URLSessionMock()
        sut = API(session: sessionMock)
    }

    func testRequestFailure() throws {
        sessionMock.error = APIError.noData
        
        var apiError: APIError?
        sut.getShows(searchTerm: "test") { result in
            switch result {
            case .success:
               break
            case .failure(let error):
                apiError = error
            }
        }
        XCTAssertNotNil(apiError)
    }
    
    func testRequestSuccess() throws {
        let testShow = Show(id: 1, name: "test", url: "test", image: nil)
        let showResults = ShowSearchResult(score: 0.5, show: testShow)
        sessionMock.data = try? JSONEncoder().encode([showResults])
        
        var returnedShow: Show?
        
        sut.getShows(searchTerm: "test") { result in
            switch result {
            case .success(let shows):
                returnedShow = shows.first
            case .failure:
                break
            }
        }
        XCTAssertEqual(returnedShow, testShow)
    }
}

private class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}

private class URLSessionMock: URLSession {

    var data: Data?
    var error: Error?
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        let data = self.data
        let error = self.error
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        return URLSessionDataTaskMock {
            completionHandler(data, response, error)
        }
    }
}
