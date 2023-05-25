//
//  WeatherResultScreenViewModel.swift
//  WeatherApp
//
//  Created by Biju Varghese on 5/24/23.
//

import Foundation

class WeatherResultScreenViewModel {
    let response: WeatherResponse
    
    var feelsLike: String {
        guard let temp = response.main?.feelsLike else {
            return "-"
        }
        return "Feels Like: \(temp)"
    }
    
    var currentTemperature: String {
        guard let temp = response.main?.temp else {
            return "-"
        }
        return "Current Temp: \(temp)"
    }
    
    var locationName: String {
        guard let name = response.name else {
            return "-"
        }
        return name
    }
    
    var daysRange: String {
        guard let tempMax = response.main?.tempMax else {
            return "-"
        }
        guard let tempMin = response.main?.tempMin else {
            return "-"
        }

        return "Days Range: \(tempMin) - \(tempMax)"
    }
    
    var clouds: String {
        guard let cloud = response.clouds?.all else {
            return "Clouds: -"
        }
        return "Clouds: \(cloud)%"

    }

    var imageUrl: URL? {
        guard let icon = response.weather?.first?.icon else {
            return nil
        }
        return URL(string: AppConfig.baseImageUrl + icon + "@2x.png")
    }

    init(response: WeatherResponse) {
        self.response = response
    }
    
    
}
