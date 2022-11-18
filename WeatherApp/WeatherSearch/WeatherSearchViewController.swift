//
//  ViewController.swift
//  WeatherApp
//
//  Created by Host on 2022-11-16.
//

import UIKit
import Combine
import CoreLocation

class WeatherSearchViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    let searchController = UISearchController(searchResultsController: ResultsViewController())
    let viewModel = WeatherSearchViewModel()
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
        switch locationManager?.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager?.requestLocation()
            default:
                debugPrint("No location obtained")
        }
        
        self.title = "WeatherApp"
        navigationController?.navigationBar.prefersLargeTitles = true
        initView()
    }
    
    func initView() {
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Location..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        viewModel.searchLocations(text: text)
        
        let searchResultsController = searchController.searchResultsController as? ResultsViewController
        searchResultsController?.viewModel = viewModel
        searchResultsController?.bindData()
    }
}


extension WeatherSearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager?.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            viewModel.getWeatherInformation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
}

