//
//  WeatherResultViewModelTest.swift
//  WeatherAppTests
//
//  Created by Biju Varghese on 5/25/23.
//

import XCTest

final class WeatherResultViewModelTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWeatherForCloud() throws {
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
        if let response = response {
            let resultVM = WeatherResultScreenViewModel(response: response)
            XCTAssertTrue(resultVM.clouds == "Clouds: 75%")
        }
    }

    func testWeatherForfeelsLike() throws {
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
        if let response = response {
            let resultVM = WeatherResultScreenViewModel(response: response)
            XCTAssertTrue(resultVM.feelsLike == "Feels Like: 83.66")
        }
    }

    func testWeatherForCurrentTemp() throws {
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
        if let response = response {
            let resultVM = WeatherResultScreenViewModel(response: response)
            XCTAssertTrue(resultVM.currentTemperature == "Current Temp: 83.25")
        }
    }

}
