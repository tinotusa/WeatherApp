//
//  WeatherUITests.swift
//  WeatherUITests
//
//  Created by Tino on 29/11/21.
//

import XCTest
@testable import Weather

class WeatherUITests: XCTestCase {
    func test_addWeatherLocation() throws {
        let app = XCUIApplication()
        app.launch()
        
        let searchBar = app.searchFields.element
        searchBar.tap()
        searchBar.typeText("Mackay\n")
        
        app.buttons["weatherButton"].firstMatch.tap()
        
        XCTAssertTrue(app.staticTexts["Mackay"].exists)
    }
    
    func test_removeWeatherLocation() {
        let app = XCUIApplication()
        app.launch()
        
        app.scrollViews.firstMatch.swipeUp()
        app.scrollViews.firstMatch.swipeDown()
        
        if app.buttons["weatherRowButton"].firstMatch.waitForExistence(timeout: 3) {
            app.buttons["weatherRowButton"].firstMatch.tap()
        }
        app.buttons["toolbarDeleteButton"].firstMatch.tap()
        app.buttons["Delete"].firstMatch.tap()
    }
    
//    func test_reorderWeatherRow() {
//        let app = XCUIApplication()
//        app.launch()
//
//        let button = app.buttons["weatherRowButton"].firstMatch
//        let otherButton = app.buttons["upgradeButton"].count
//        if button.waitForExistence(timeout: 3) {
//            button.press(forDuration: 1, thenDragTo: otherButton)
//        }
//    }
}
