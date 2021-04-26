//
//  MoviesAppUITests.swift
//  MoviesAppUITests
//
//  Created by Joanna Zatorska on 17/04/2021.
//

import XCTest

class MoviesAppUITests: XCTestCase {

    var app = XCUIApplication()
    
    override func setUpWithError() throws {
        app.launchArguments.append(contentsOf: [ "--uitesting"])
        app.launch()
    }

    func testGettingShowsAndMarkingFavourite() {
        let searchField = app.textFields["Search for shows..."]
        XCTAssert(searchField.waitForExistence(timeout: 10), "Search text field should exist.")
        searchField.tap()
        
        searchField.typeText("Bank")
        
        let cell = app.staticTexts["The Bank Hacker"].firstMatch
        XCTAssert(cell.waitForExistence(timeout: 10), "There should be some results with Bank.")
        
        let cell2 = app.staticTexts["The South Bank Show Originals"].firstMatch
        XCTAssert(cell2.waitForExistence(timeout: 10), "There should be more results with Bank.")
        
        cell.tap()
        
        let toggle = app.switches["Set favourite"]
        XCTAssert(toggle.waitForExistence(timeout: 10), "There should be favourite toggle.")
        toggle.tap()
        
        let backButton = app.buttons["Back"]
        backButton.tap()
        
        let favToggle = app.switches["Show favourites"]
        XCTAssert(favToggle.waitForExistence(timeout: 10), "There should be favourite filter toggle.")
        favToggle.tap()
        
        let filteredCell = app.staticTexts["The Bank Hacker"].firstMatch
        XCTAssert(filteredCell.waitForExistence(timeout: 10), "There should be some results with Bank.")
        
        let notVisibleCell = app.staticTexts["The South Bank Show Originals"].firstMatch
        XCTAssertFalse(notVisibleCell.waitForExistence(timeout: 5))
    }
}
