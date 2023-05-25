//
//  WeatherAPIManager.swift
//  WeatherApp
//
//  Created by Biju Varghese on 5/24/23.
//

import Foundation
typealias WeatherResponseClosure = (Result<WeatherResponse, WeatherAppError>) -> Void
typealias GeoCoderResponseClosure = (Result<GeocoderResponse, WeatherAppError>) -> Void

protocol OpenWeatherAPI {
    func callWeatherAPI(location: Location, completion: WeatherResponseClosure?)
    func callGEOCoderAPI(textValue: String, completion: GeoCoderResponseClosure?)
}


class WeatherApiManager: OpenWeatherAPI {
    var weatherServiceInvoker: ServiceInvoker<WeatherResponse>?
    var geoCoderServiceInvoker: ServiceInvoker<GeocoderResponse>?

    func callGEOCoderAPI(textValue: String, completion: GeoCoderResponseClosure?) {
        let urlStr = AppConfig.baseurl + AppConfig.geoAPI +  "q=\(textValue)&limit=\(AppConfig.geoAPILimit)&appid=\(AppConfig.apiKey)&units=imperial"
        print(urlStr)
        self.geoCoderServiceInvoker = ServiceInvoker<GeocoderResponse>(urlString: urlStr)
        geoCoderServiceInvoker?.getData(completion: { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                // For now we can map all errors from network to a single error as failed network
                switch error {
                case .emptyURL, .urlCreationFailure, .urlRequestCreationFailure, .errorParsingJson, .emptyData, .unknownError:
                    completion?(.failure(.apiError))
                }
            }
        })

    }
    
    func callWeatherAPI(location: Location, completion: WeatherResponseClosure?) {
        // https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
        let urlStr = AppConfig.baseurl + AppConfig.weatherAPI + "lat=\(location.latitude)&lon=\(location.longitude)&appid=\(AppConfig.apiKey)&units=imperial"
        print(urlStr)
        self.weatherServiceInvoker = ServiceInvoker<WeatherResponse>(urlString: urlStr)
        self.weatherServiceInvoker?.getData { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                // For now we can map all errors from network to a single error as failed network
                switch error {
                case .emptyURL, .urlCreationFailure, .urlRequestCreationFailure, .errorParsingJson, .emptyData, .unknownError:
                    completion?(.failure(.apiError))
                }
            }
        }
    }
    
    
    
}
