//
//  StorageProvider.swift
//  WeatherApp
//
//  Created by Biju Varghese on 5/25/23.
//

import Foundation
protocol StrorageProvider {
    func getValue(key: String) -> String?
    func setValue(key: String, value: String)
}

class Storage: StrorageProvider {
    
    let defaults = UserDefaults.standard
    
    func getValue(key: String) -> String? {
        return defaults.value(forKey: key) as? String
    }
    
    func setValue(key: String, value: String) {
        defaults.setValue(value, forKey: key)
    }
    
}

struct StorageKeys {
    static let lastSearchedLocation = "lastSearched"
}
