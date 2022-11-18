//
//  Wind.swift
//  WeatherApp
//
//  Created by Host on 2022-11-18.
//

import Foundation

class Wind: Codable {
    let speed: Double?
    let degrees: Double?
    let gust: Double?
    
    enum CodingKeys: String, CodingKey {
        case speed
        case degrees = "deg"
        case gust
    }
}
