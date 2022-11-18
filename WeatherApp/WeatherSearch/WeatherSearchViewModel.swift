//
//  ViewModel.swift
//  WeatherApp
//
//  Created by Host on 2022-11-18.
//

import Combine
import Foundation
import CoreLocation

final class WeatherSearchViewModel {
    
    @Published var index: Int = 0
    @Published var locations: [LocationsResponse]?
    @Published var weatherResponse : WeatherResponse?
    
    private var cancellable: AnyCancellable?
    
    private let networkManager = NetworkManager()
    let indexPublisher = NotificationCenter.Publisher(center: .default, name: .selectedLocationIndex, object: nil)
    
    init() {
        cancellable = $index.sink {[weak self] value in
            if let location = self?.locations?[value] {
                self?.getWeatherInformation(latitude: location.latitude, longitude: location.longitude)
            }
        }
    }
    
    func searchLocations(text: String) {
        if text.isEmpty { return }
        networkManager.getLocations(query: text) { [weak self] results in
            self?.locations = results
        }
    }
    
    func getWeatherInformation(latitude: Double, longitude: Double) {
        print(latitude)
        print(longitude)
        networkManager.getWeather(latitude: latitude, longitude: longitude) { [weak self] response in
            self?.weatherResponse = response
        }
    }
}


extension Notification.Name {
    static let selectedLocationIndex = Notification.Name("selected_location_index")
}
