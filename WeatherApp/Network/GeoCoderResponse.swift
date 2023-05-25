//
//  GeoCoderResponse.swift
//  WeatherApp
//
//  Created by Biju Varghese on 5/24/23.
//
// https://api.openweathermap.org/geo/1.0/direct?q=London&limit=2&appid=537d73fbddd2d5e904facbc0bf26849b
import Foundation
struct GeocoderResponseElement: Codable {
    let name: String?
    let localNames: [String: String]?
    let lat, lon: Double?
    let country, state: String?

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat, lon, country, state
    }
}

typealias GeocoderResponse = [GeocoderResponseElement]
