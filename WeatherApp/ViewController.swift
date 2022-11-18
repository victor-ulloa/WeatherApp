//
//  ViewController.swift
//  WeatherApp
//
//  Created by Host on 2022-11-16.
//

import UIKit

class ViewController: UIViewController {
    
    let networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        networkManager.getLocations(query: "London") { _ in
            
        }
        
        networkManager.getWeather(lat: 51.5073219, lon: -0.1276474) { _ in
            
        }
        
    }


}

