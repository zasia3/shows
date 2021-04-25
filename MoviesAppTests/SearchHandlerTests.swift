//
//  SearchHandlerTests.swift
//  MoviesAppTests
//
//  Created by Joanna Zatorska on 17/04/2021.
//

import XCTest
@testable import MoviesApp
import API
import Models

class SearchHandlerTests: XCTestCase {
    
    var sut: SearchHandler!
    fileprivate var apiMock = APIMock()
    fileprivate var delegate = DelegateMock()

    override func setUpWithError() throws {
        sut = SearchHandler(api: apiMock)
        sut.delegate = delegate
    }

    func testSuccessfulSearch() throws {
        let show = Show(id: 1, name: "test", url: "https://test.com")
        let showResult = ShowSearchResult(score: 2.03, show: show)
        apiMock.showsToReturn = [showResult]
        sut.search(for: "test")
        XCTAssertEqual(delegate.shows?.first?.id, show.id)
    }
    func testFailingSearch() throws {
        apiMock.errorToReturn = APIError.noData
        sut.search(for: "test")
        XCTAssertNotNil(delegate.error)
    }
}

private class DelegateMock: SearchHandlerDelegate {
    var shows: [Show]?
    var error: APIError?
    func didFind(shows: [Show]) {
        self.shows = shows
    }
    
    func didReceiveError(_ error: APIError) {
        self.error = error
    }
}

private class APIMock: APIProtocol {
    var errorToReturn: APIError?
    var showsToReturn: [ShowSearchResult]?
    func getShows(searchTerm term: String, completion: @escaping (Result<[ShowSearchResult], APIError>) -> Void) {
        if let error = errorToReturn {
            completion(.failure(error))
            return
        }
        if let showResults = showsToReturn {
            completion(.success(showResults))
        }
        
    }
}
