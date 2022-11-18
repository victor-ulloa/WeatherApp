//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Host on 2022-11-17.
//

import Foundation

class WeatherResponse: Codable {
    let coordinates: Coordinates
    let weather: [Weather]
    let weatherData: WeatherData
    let visibility: Int?
    let wind: Wind?
    let snow: Snow?
    let systemData: SystemData?
    let timezone: Int?
    let cityName: String?
    
    enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case weather
        case weatherData = "main"
        case visibility
        case wind
        case snow
        case systemData = "sys"
        case timezone
        case cityName = "city"
    }
}
