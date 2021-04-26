//
//  DetailsLoaderTests.swift
//  DataLoaderTests
//
//  Created by Joanna Zatorska on 26/04/2021.
//

import XCTest
@testable import DataLoader
import API
import Models

class DetailsLoaderTests: XCTestCase {
    
    let crew = [CrewMember(type: .producer, person: Person(id: 1, name: "Jaś Fasola"))]
    let episodes = [Episode(id: 1, name: "test", airdate: "2011-03-06", airtime: "", summary: nil)]
    let testShow = Show(id: 1, name: "test", url: "test", image: nil)
    
    var sut: DetailsLoader!
    fileprivate var apiMock: APIMock!
    
    override func setUpWithError() throws {
        apiMock = APIMock()
        sut = DetailsLoader(api: apiMock)
    }
    
    func testSuccessfulDownload() {
        apiMock.crewToReturn = crew
        apiMock.episodesToReturn = episodes
        
        let expect = expectation(description: #function)
        var showDetails: ShowDetails?
        sut.loadDetails(of: testShow) { details in
            showDetails = details
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 2) { (error) in
            XCTAssertNotNil(showDetails)
            XCTAssert(showDetails?.crew.first?.type == self.crew.first?.type)
            XCTAssert(showDetails?.episodes.first?.id == self.episodes.first?.id)
        }
    }
    
    func testUnsuccessfulDownload() {
        apiMock.errorToReturn = .noData
        
        let expect = expectation(description: #function)
        var showDetails: ShowDetails?
        sut.loadDetails(of: testShow) { details in
            showDetails = details
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 2) { (error) in
            XCTAssertNotNil(showDetails)
            XCTAssert(showDetails?.crew.count == 0)
            XCTAssert(showDetails?.episodes.count == 0)
        }
    }
}

private class APIMock: ShowDetailsAPIProtocol {
    var crewToReturn: [CrewMember]?
    var errorToReturn: APIError?
    var episodesToReturn: [Episode]?
    func getCrew(showId: String, completion: @escaping (Result<[CrewMember], APIError>) -> Void) {
        if let crew = crewToReturn {
            completion(.success(crew))
            return
        }
        if let error = errorToReturn {
            completion(.failure(error))
        }
    }
    
    func getEpisodes(showId: String, completion: @escaping (Result<[Episode], APIError>) -> Void) {
        if let episodes = episodesToReturn {
            completion(.success(episodes))
            return
        }
        if let error = errorToReturn {
            completion(.failure(error))
        }
    }
}
