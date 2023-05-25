//
//  TestHelper.swift
//  WeatherAppTests
//
//  Created by Biju Varghese on 5/25/23.
//

import Foundation
import XCTest
class TestHelper {
    
     func loadTestData<T: Codable>(fileName: String, ofType: String = "json") -> T? {
         let bundle = Bundle(for: TestHelper.self)
         guard let url = bundle.url(forResource: fileName, withExtension: ofType) else {
            return nil
        }
        if let data = try? Data(contentsOf: url, options: .mappedIfSafe), let response = try? JSONDecoder().decode(T.self, from: data) {
            return response
        }
        return nil
    }
}


class MockedWeatherAPI: OpenWeatherAPI {
    var simulateFailure = false
    
    func callWeatherAPI(location: Location, completion: WeatherResponseClosure?) {
        guard let testData: WeatherResponse = TestHelper().loadTestData(fileName: "MockedWeatherResponse") else {
            completion?(.failure(.apiError))
            return
        }
        completion?(.success(testData))
    }
    
    func callGEOCoderAPI(textValue: String, completion: GeoCoderResponseClosure?) {
        guard let testData: GeocoderResponse = TestHelper().loadTestData(fileName: "MockedGeocoderResponse") else {
            completion?(.failure(.apiError))
            return
        }
        completion?(.success(testData))
    }
    
    
}

class MockedLocationFinder: LocationFindable {
    func requestLocation(completion: LocationFinderResponseClosure?) {
        completion?(.success(Location(latitude: 33.14, longitude: 32.14)))
    }
    
    func isLocationServicesAllowed() -> (isAuthorized: Bool, isDetermined: Bool) {
        return (true, true)
    }
    
    
}

class MockedStorage: StrorageProvider {
    func getValue(key: String) -> String? {
        return "Irving"
    }
    
    func setValue(key: String, value: String) {
        
    }
}
