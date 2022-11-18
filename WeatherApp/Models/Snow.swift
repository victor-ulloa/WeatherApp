//
//  Snow.swift
//  WeatherApp
//
//  Created by Host on 2022-11-18.
//

import Foundation

class Snow: Codable {
    let hour1: Double?
    let hour3: Double?
    
    enum CodingKeys: String, CodingKey {
        case hour1 = "1h"
        case hour3 = "3h"
    }
}
