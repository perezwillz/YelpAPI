//
//  WeedmapsChallengeUITests.swift
//  WeedmapsChallengeUITests
//
//  Created by Perez Willie Nwobu on 3/8/20.
//  Copyright © 2020 Weedmaps, LLC. All rights reserved.
//

import XCTest

class WeedmapsChallengeUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testForHistoryAndTabBar() {
          // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        app.navigationBars["Businesses Near You"].buttons["History"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 0).swipeDown()
        app.tabBars.buttons["Favorites"].tap()
    
      }
}
