//
//  Weather.swift
//  WeatherApp
//
//  Created by Host on 2022-11-18.
//

import Foundation

class Weather: Codable {
    let _id: Int
    let main: String?
    let description: String?
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case _id = "id"
        case main
        case description
        case icon
    }
}
