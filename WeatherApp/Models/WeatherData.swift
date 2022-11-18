//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Host on 2022-11-18.
//

import Foundation

class WeatherData: Codable {
    let temperature: Double?
    let feelsLike: Double?
    let minTemperature: Double?
    let maxTemperature: Double?
    let pressure: Double?
    let humidity: Double?
    let seaLevel: Double?
    let groundLevel: Double?
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
        case pressure
        case humidity
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"
    }
}
