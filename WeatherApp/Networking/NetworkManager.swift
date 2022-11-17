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
    case locations = ""
    case weather = "/geo/1.0/direct"
}

struct NetworkManager {
    
    static let baseUrl = "api.openweathermap.org"
    static let APIKey = "e60fc6752c621242b66596b4ccabf2f2"
    
    
    func fetchLocations(query: String, completionHandler: @escaping ([LocationsResponse]) -> Void) {
        
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
        
        
//        let task_ = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//            if let error = error {
//                print("Error with fetching films: \(error)")
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse,
//                  (200...299).contains(httpResponse.statusCode) else {
//                print("Error with the response, unexpected status code: \(response)")
//                return
//            }
//
//            if let data = data,
//               let locationsResponse = try? JSONDecoder().decode(LocationsResponse.self, from: data) {
//                completionHandler(locationsResponse)
//            }
//        })
//        task.resume()
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


