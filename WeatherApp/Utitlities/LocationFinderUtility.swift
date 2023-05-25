//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Biju Varghese on 5/24/23.
//

import Foundation
import CoreLocation


enum WeatherAppError: Error {
    case noLocationsFound
    case permissionError
    case apiError
    case geocoderError
    case unknownError
    case locationInputEmptyError
    // can be given a more meaningful error title
    var title: String {
        get {
            switch self {
            case .noLocationsFound:
                return "Error"
            case .permissionError:
                return "Error"
            case .unknownError:
                return "Error"
            case .apiError:
                return "Network Error"
            case .geocoderError:
                return "Geo Coder Error"
            case .locationInputEmptyError:
                return "Empty Location Text"
            }
        }
    }
    
    var message: String {
        get {
            switch self {
            case .noLocationsFound:
                return "No locations found"
            case .permissionError:
                return "Please provide location access"
            case .unknownError:
                return "UnknowError"
            case .apiError:
                return "API errror"
            case .geocoderError:
                return "Geocoder error - lat or lon missing"
            case .locationInputEmptyError:
                return "Empty location provided in text field"
            }
        }
    }
}

struct Location {
    let latitude: Double
    let longitude: Double
}


// using a type alias for closure
typealias LocationFinderResponseClosure = (Result<Location, WeatherAppError>) -> Void
protocol LocationFindable {
    func requestLocation(completion: LocationFinderResponseClosure?)
    func isLocationServicesAllowed() -> (isAuthorized: Bool, isDetermined: Bool)
}

class LocationFinderUtility: NSObject, LocationFindable {
    
    private let locationManager = CLLocationManager()
    // making closure as an optional makes it a escaping closure
    var completion: LocationFinderResponseClosure?

    // Request the location and let the caller know by sending
    func requestLocation(completion: LocationFinderResponseClosure?) {
        self.completion = completion
        locationManager.delegate = self
        checkPermissionAndRequestLcoation()
    }
    
    /*
     1. checks if a user has given permission then request for location
     2. check if the user is yet to give permission and ask for permission.
     3. no permission is given so a failure and that is notified to user
     */
    func checkPermissionAndRequestLcoation() {
        let (isAllowed, isDetermined) = isLocationServicesAllowed()
        if isAllowed == true && isDetermined == true {
            locationManager.requestLocation()
        } else if isDetermined == false {
            locationManager.requestWhenInUseAuthorization()
        } else {
            completion?(.failure(.permissionError))
        }
    }
    
    func isLocationServicesAllowed() -> (isAuthorized: Bool, isDetermined: Bool) {
        var isAllowed = false
        var isDetermined = false // this is true when its authorized, denied, restricted as user has given intention to block the location
        let status = locationManager.authorizationStatus
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            isAllowed = true
            isDetermined = true
        case .denied, .restricted:
            isAllowed = false
            isDetermined = true
        case .notDetermined:
            isDetermined = false
            // this value is of not used when the user status is not determined
            isAllowed = false
        @unknown default:
            isAllowed = false
            isDetermined = false
        }
        return (isAuthorized: isAllowed, isDetermined: isDetermined)
    }
    
}

extension LocationFinderUtility: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkPermissionAndRequestLcoation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == CLError.Code.denied {
            self.completion?(.failure(.permissionError))
        }
        print("location \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let loc = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.latitude)
            self.completion?(.success(loc))
        } else {
            self.completion?(.failure(.noLocationsFound))
        }
    }
}
