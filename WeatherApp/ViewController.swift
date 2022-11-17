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
        
        networkManager.fetchLocations(query: "London") { _ in
            
        }
        
    }


}

