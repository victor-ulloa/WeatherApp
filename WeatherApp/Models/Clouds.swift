//
//  Clouds.swift
//  WeatherApp
//
//  Created by Host on 2022-11-18.
//

import Foundation

class Clouds: Codable {
    let cloudiness: Double
    
    enum CodingKeys: String, CodingKey {
        case cloudiness = "all"
    }
}
