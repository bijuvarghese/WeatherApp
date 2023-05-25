//
//  WeatherHomeScreenViewModel.swift
//  WeatherApp
//
//  Created by Biju Varghese on 5/24/23.
//

import Foundation

enum ViewState {
    case result(WeatherResponse), error(WeatherAppError), loading
}

typealias ViewActionClosure = (ViewState) -> Void

class WeatherHomeScreenViewModel {

    private let locationFinder: LocationFindable
    private let storage: StrorageProvider
    private let weatherApiManager: OpenWeatherAPI
    private var viewStates: ViewState = .loading
    private var actions: ViewActionClosure?
    
    var lastSerachedLocation: String? {
        storage.getValue(key: StorageKeys.lastSearchedLocation)
    }
    
    init(locationFinder: LocationFindable, storage: StrorageProvider, weatherApiManager: OpenWeatherAPI, viewStates: ViewState = .loading, actions: ViewActionClosure? = nil) {
        self.locationFinder = locationFinder
        self.storage = storage
        self.weatherApiManager = weatherApiManager
        self.viewStates = viewStates
        self.actions = actions
    }
        
    // this method can be called from viewWillAppear or viewDidLoad, for now only to be called in viewDidLoad
    func requestLocation() {
        self.actions?(.loading)
        if let lastSearchedLocation = lastSerachedLocation {
            callGeoCoderAPI(text: lastSearchedLocation)
        } else {
            self.locationFinder.requestLocation { [weak self] result in
                switch result {
                case .success(let location):
                    print("Found location ---- \(location)")
                    // got the location so call the weather api
                    self?.callWeatherAPI(location: location)
                case .failure(let error):
                    print(error)
                    // Notify UI
                    self?.actions?(.error(error))
                }
            }
        }
    }
    
    func callWeatherAPI(location: Location) {
        print("Calling weather api ---- \(location)")
        self.weatherApiManager.callWeatherAPI(location: location) { [weak self] result in
            switch result {
            case .success(let response):
                // Notify UI
                self?.actions?(.result(response))
            case .failure(let error):
                // Notify UI
                self?.actions?(.error(error))
            }
        }
    }
    
    func callGeoCoderAPI(text: String) {
        print("Calling geo coder api ---\(text)")
        self.actions?(.loading)
        self.weatherApiManager.callGEOCoderAPI(textValue: text) { [weak self] result in
            switch result {
            case .success(let response):
                if let lat = response.first?.lat, let lon = response.first?.lon {
                    let loc = Location(latitude: lat, longitude: lon)
                    // saving only if a success full geocoding happened
                    self?.storage.setValue(key: StorageKeys.lastSearchedLocation, value: text)
                    self?.callWeatherAPI(location: loc)
                } else {
                    // Notify UI
                    self?.actions?(.error(.geocoderError))
                }
            case .failure(let error):
                // Notify UI
                self?.actions?(.error(error))
            }
        }
    }
    
    func isValidInput(text: String) -> Bool {
        if text.isEmpty {
            return false
        }
        return true
    }    
}



