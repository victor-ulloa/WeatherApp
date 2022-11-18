//
//  ViewModel.swift
//  WeatherApp
//
//  Created by Host on 2022-11-18.
//

import Foundation

final class WeatherSearchViewModel {
    
    private let networkManager = NetworkManager()
    
    init() {
        networkManager.getLocations(query: "London") { _ in
            
        }
        
        networkManager.getWeather(lat: 51.5073219, lon: -0.1276474) { _ in
            
        }
    }
    
    
}
