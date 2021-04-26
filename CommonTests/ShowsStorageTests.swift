//
//  CommonTests.swift
//  CommonTests
//
//  Created by Joanna Zatorska on 26/04/2021.
//

import XCTest
@testable import Common
import Models

class ShowsStorageTests: XCTestCase {
    
    let testShow = Show(id: 1, name: "test", url: "test", image: nil)
    let testShow2 = Show(id: 2, name: "test", url: "test", image: nil)
    
    var sut: ShowsStorage!

    override func setUpWithError() throws {
        sut = ShowsStorage(defaults: UserDefaults.standard)
    }
    
    override func tearDown() {
        sut.clear()
    }
    
    func testAddingShows() {
        sut.add(testShow.id)
        
        let ids = sut.favouriteShowIds()
        XCTAssert(testShow.id == ids.first)
    }
    
    func testAddingSameShows() {
        sut.add(testShow.id)
        sut.add(testShow.id)
        
        let ids = sut.favouriteShowIds()
        XCTAssert(ids.count == 1)
    }
    
    func testRemovingShows() {
        sut.add(testShow.id)
        sut.delete(testShow.id)
        let ids = sut.favouriteShowIds()
        XCTAssert(ids.isEmpty)
    }
    
    func testRemovingVariousShows() {
        sut.add(testShow.id)
        sut.add(testShow2.id)
        sut.delete(testShow.id)
        let ids = sut.favouriteShowIds()
        XCTAssert(ids.count == 1)
    }
    
    func testClearingStorage() {
        sut.add(testShow.id)
        sut.clear()
        let ids = sut.favouriteShowIds()
        XCTAssert(ids.isEmpty)
    }
}
