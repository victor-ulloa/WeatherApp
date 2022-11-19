//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Host on 2022-11-16.
//

import Foundation

enum HTTPMethod : String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum Path : String {
    case locations = "/data/2.5/weather"
    case weather = "/geo/1.0/direct"
}

protocol NetworkManagerProtocol {
    func getLocations(query: String, completionHandler: @escaping ([LocationsResponse]) -> Void)
    func getWeather(latitude: Double, longitude: Double, completionHandler: @escaping (WeatherResponse) -> Void)
}

struct NetworkManager: NetworkManagerProtocol {
    
    static let baseUrl = "api.openweathermap.org"
    static let APIKey = "e60fc6752c621242b66596b4ccabf2f2"
    
    func getLocations(query: String, completionHandler: @escaping ([LocationsResponse]) -> Void) {
        
        let queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "limit", value: "5"),
            URLQueryItem(name: "appid", value: NetworkManager.APIKey)
        ]
        
        guard let url = buildUrl(path: .weather, queryItems: queryItems) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  error == nil
            else {                                                               // check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            do {
                let locationsResponse = try JSONDecoder().decode([LocationsResponse].self, from: data)
                completionHandler(locationsResponse)
            } catch {
                print(error) // parsing error
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                } else {
                    print("unable to parse response as string")
                }
            }
        }
        
        task.resume()
    }
    
    func getWeather(latitude: Double, longitude: Double, completionHandler: @escaping (WeatherResponse) -> Void) {
        let queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(longitude)),
            URLQueryItem(name: "appid", value: NetworkManager.APIKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        guard let url = buildUrl(path: .locations, queryItems: queryItems) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  error == nil
            else {                                                               // check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completionHandler(weatherResponse)
            } catch {
                print(error) // parsing error
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                } else {
                    print("unable to parse response as string")
                }
            }
        }
        
        task.resume()
    }
    
    private func buildUrl(path: Path, queryItems: [URLQueryItem]) -> URL? {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = NetworkManager.baseUrl
        components.path = path.rawValue
        components.queryItems = queryItems
        
        return components.url
    }
    
}


