//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import XCTest
@testable import WeedmapsChallenge


class YelpAPIClientTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testStringExtensions() {
        //use mock data to make sure struct is decpoding properly
        let testUrl = "https://api.yelp.com/v3"
        let testValue = "ice cream"
        let appendPathComponent1 = "businesses"
        let appendPathComponent2 = "search"
        let locationAlertTitle = "Uh oh"
        let noLocation = "No location"
        let openIn = "Open in"
        let safari = "Safari"
        let inApp = "Open in"
        let cancel = "Open in"
        
        XCTAssertEqual(String.testUrl, testUrl)
        XCTAssertEqual(String.testValue, testValue)
        XCTAssertEqual(String.appendPathComponent1, appendPathComponent1)
        XCTAssertEqual(String.appendPathComponent2, appendPathComponent2)
        XCTAssertEqual(String.locationAlertTitle, locationAlertTitle)
        XCTAssertEqual(String.noLocation, noLocation)
        XCTAssertEqual(String.openIn, openIn)
        XCTAssertEqual(String.safari, safari)
        XCTAssertEqual(String.inApp, inApp)
        XCTAssertEqual(String.cancel, cancel)
    }
    
    func testBusinessModelDecodedFromJsonYieldsExpectedResult() {
        //use mock data to make sure struct is decpoding properly
        guard let data = String.json else {
            XCTFail(Errors.noDataReturned.rawValue)
            return
        }
        do {
            let searchResult = try JSONDecoder().decode(BusinessesList.self, from: data)
            XCTAssertNotNil(searchResult)
        } catch {
            XCTFail(Errors.decodingDataFailed.rawValue)
        }
    }
    
    func testYelpAPIRequestYieldsExpectedResult() {
        let yelpApiSucessExpectation = expectation(description: "yelpApiSucessExpectation")
        YelpManager().search(term: "Coffee", latitude: "51.507351", longitude: "-0.127758", page: 1) { (success, error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            guard let _ = success else {
                XCTFail(Errors.noDataReturned.rawValue)
                return
            }
            // Fulfull Accomplishment
            yelpApiSucessExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
