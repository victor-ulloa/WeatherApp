//
//  Coordinates.swift
//  WeatherApp
//
//  Created by Host on 2022-11-18.
//

import Foundation

class Coordinates: Codable {
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}
