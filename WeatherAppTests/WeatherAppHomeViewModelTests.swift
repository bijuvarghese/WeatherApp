//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Biju Varghese on 5/24/23.
//

import XCTest

final class WeatherAppHomeViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLastSearchedLocation() throws {
        let hmv = WeatherHomeScreenViewModel(locationFinder: MockedLocationFinder(), storage: MockedStorage(), weatherApiManager: MockedWeatherAPI())
        XCTAssertTrue(hmv.lastSerachedLocation ?? "" == "Irving")        
    }
    
    func testValidateTextWithValue() throws {
        let hmv = WeatherHomeScreenViewModel(locationFinder: MockedLocationFinder(), storage: MockedStorage(), weatherApiManager: MockedWeatherAPI())
        XCTAssertTrue(hmv.isValidInput(text: "Irving") == true)

    }
    
    func testValidateTextWithoutValue() throws {
        let hmv = WeatherHomeScreenViewModel(locationFinder: MockedLocationFinder(), storage: MockedStorage(), weatherApiManager: MockedWeatherAPI())
        XCTAssertTrue(hmv.isValidInput(text: "") == false)
    }
    
    func testWeatherResponseCall() throws {
        var response: WeatherResponse?
        let expectation = self.expectation(description: "Get Weather Response")
        let hmv = WeatherHomeScreenViewModel(locationFinder: MockedLocationFinder(), storage: MockedStorage(), weatherApiManager: MockedWeatherAPI()) { state in
            switch state {
            case .result(let r):
                print(r)
                response = r
                expectation.fulfill()
            case .error(_):
                expectation.fulfill()
            case .loading:
                break
            }
        }
        hmv.callWeatherAPI(location: Location(latitude: 3.33, longitude: 3.22))
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(response)
    }

    func testGeoCoderResponseCall() throws {
        var response: WeatherResponse?
        let expectation = self.expectation(description: "Get Weather Response")
        let hmv = WeatherHomeScreenViewModel(locationFinder: MockedLocationFinder(), storage: MockedStorage(), weatherApiManager: MockedWeatherAPI()) { state in
            switch state {
            case .result(let r):
                print(r)
                response = r
                expectation.fulfill()
            case .error(_):
                expectation.fulfill()
            case .loading:
                break
            }
        }
        hmv.callGeoCoderAPI(text: "Test")
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(response)
    }

}

