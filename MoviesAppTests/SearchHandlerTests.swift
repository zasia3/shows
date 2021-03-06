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
        let show = Show(id: 1, name: "test", url: "https://test.com", image: nil)
        apiMock.showsToReturn = [show]
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
    var showsToReturn: [Show]?
    var crewToReturn: [CrewMember]?
    var episodesToReturn: [Episode]?
    
    func getShows(searchTerm term: String, completion: @escaping (Result<[Show], APIError>) -> Void) {
        if let error = errorToReturn {
            completion(.failure(error))
            return
        }
        if let showResults = showsToReturn {
            completion(.success(showResults))
        }
    }
    
    func getCrew(showId: String, completion: @escaping (Result<[CrewMember], APIError>) -> Void) {
        if let error = errorToReturn {
            completion(.failure(error))
            return
        }
        if let crewToReturn = crewToReturn {
            completion(.success(crewToReturn))
        }
    }
    
    func getEpisodes(showId: String, completion: @escaping (Result<[Episode], APIError>) -> Void) {
        if let error = errorToReturn {
            completion(.failure(error))
            return
        }
        if let episodesToReturn = episodesToReturn {
            completion(.success(episodesToReturn))
        }
    }
}
