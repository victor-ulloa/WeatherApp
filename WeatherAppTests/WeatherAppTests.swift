//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Host on 2022-11-16.
//

import XCTest
@testable import WeatherApp

final class WeatherAppTests: XCTestCase {
    
    func test_getLocations() {
        let networkManager = MockNetworkManager()
        
        let expectation = self.expectation(description: "Valid_Requests_LocationsResponse_array")
        
        networkManager.getLocations(query: "London") { response in
            XCTAssertNotNil(response)
            XCTAssertEqual(response.first?.name, "London")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func test_getWeather() {
        let networkManager = MockNetworkManager()
        
        let expectation = self.expectation(description: "Valid_Requests_LocationsResponse_array")
        
        networkManager.getWeather(latitude: 10.99, longitude: 44.34) { response in
            XCTAssertNotNil(response)
            XCTAssertEqual(response.cityName, "Zocca")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
}


final class MockNetworkManager: NetworkManagerProtocol {
    
    func getLocations(query: String, completionHandler: @escaping ([WeatherApp.LocationsResponse]) -> Void) {
        let filePath = "locations"
        MockNetworkManager.loadJsonDataFromFile(filePath, completion: { data in
            if let json = data {
                do {
                    let locations = try JSONDecoder().decode([WeatherApp.LocationsResponse].self, from: json)
                    completionHandler(locations)
                }
                catch _ as NSError {
                    fatalError("Couldn't load data from \(filePath)")
                }
            }
        })
        
    }
    
    func getWeather(latitude: Double, longitude: Double, completionHandler: @escaping (WeatherApp.WeatherResponse) -> Void) {
        let filePath = "weather"
        MockNetworkManager.loadJsonDataFromFile(filePath, completion: { data in
            if let json = data {
                do {
                    let weather = try JSONDecoder().decode(WeatherApp.WeatherResponse.self, from: json)
                    completionHandler(weather)
                }
                catch _ as NSError {
                    fatalError("Couldn't load data from \(filePath)")
                }
            }
        })
    }
    
    private static func loadJsonDataFromFile(_ path: String, completion: (Data?) -> Void) {
        if let fileUrl = Bundle(for: WeatherAppTests.self).url(forResource: path, withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileUrl, options: [])
                completion(data as Data)
            } catch (let error) {
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
}
