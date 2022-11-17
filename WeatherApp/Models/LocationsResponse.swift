//
//  LocationsResponse.swift
//  WeatherApp
//
//  Created by Host on 2022-11-16.
//

import Foundation

class LocationsResponse: Codable {
    let name: String
    let localNames: LocalNames?
    let latitude: Double
    let longitude: Double
    let country: String
    let state: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case latitude = "lat"
        case longitude = "lon"
        case country
        case state
    }
}

class LocalNames: Codable {
    let ascii: String?
}
