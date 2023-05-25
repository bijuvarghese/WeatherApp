//
// WeatherErrorScreenViewModel.swift
//  WeatherApp
//
//  Created by Biju Varghese on 5/24/23.
//

import Foundation



class WeatherErrorScreenViewModel {
    
    var error: WeatherAppError
        
    var errorMessage: String {
        return error.message
    }
    
    var errorTitle: String {
        return error.title
    }
    
    init(error: WeatherAppError) {
        self.error = error
    }
}
