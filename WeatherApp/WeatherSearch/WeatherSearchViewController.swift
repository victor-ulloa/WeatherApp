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
    
    lazy var noLocationLabel = UILabel()
    
    lazy var mainScrollView = UIScrollView()
    lazy var mainStackView = UIStackView()
    
    lazy var headerStackView = UIStackView()
    lazy var cityLabel = UILabel()
    lazy var temperatureLabel = UILabel()
    lazy var descriptionLabel = UILabel()
    
    lazy var subHeaderStackView = UIStackView()
    lazy var lowestTempLabel = UILabel()
    lazy var highestTempLabel = UILabel()
    
    lazy var contentStackView = UIStackView()
    
    lazy var feelsLikeStackView = UIStackView()
    lazy var feelsLikeImageView = UIImageView()
    lazy var feelsLikeLabel = UILabel()
    
    lazy var windSpeedStackView = UIStackView()
    lazy var windSpeedImageView = UIImageView()
    lazy var windSpeedLabel = UILabel()
    
    lazy var pressureStackView = UIStackView()
    lazy var pressureImageView = UIImageView()
    lazy var pressureLabel = UILabel()
    
    lazy var humidityStackView = UIStackView()
    lazy var humidityImageView = UIImageView()
    lazy var humidityLabel = UILabel()
    
    
    let searchController = UISearchController(searchResultsController: ResultsViewController())
    let viewModel = WeatherSearchViewModel()
    
    var locationManager: CLLocationManager?
    private var cancellable: AnyCancellable?
    
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
        setUpSearchBar()
        setUpViews()
        setUpConstraints()
        bindData()
    }
    
    func setUpSearchBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Location..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func setUpViews() {
        view.backgroundColor = .white
        
        noLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        noLocationLabel.font = .systemFont(ofSize: 20)
        noLocationLabel.text = "No location has been selected"
        view.addSubview(noLocationLabel)
        
        
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainScrollView)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.alignment = .center
        mainStackView.distribution = .fillProportionally
        mainStackView.axis = .vertical
        mainStackView.spacing = 30
        mainScrollView.addSubview(mainStackView)
        
        //        MARK: - Header
        headerStackView.alignment = .center
        headerStackView.distribution = .fillProportionally
        headerStackView.axis = .vertical
        headerStackView.spacing = 5
        mainStackView.addArrangedSubview(headerStackView)
        
        cityLabel.font = .systemFont(ofSize: 30, weight: .medium)
        cityLabel.textAlignment = .center
        cityLabel.numberOfLines = 0
        headerStackView.addArrangedSubview(cityLabel)
        
        temperatureLabel.font = .systemFont(ofSize: 60)
        temperatureLabel.textAlignment = .center
        temperatureLabel.numberOfLines = 0
        headerStackView.addArrangedSubview(temperatureLabel)
        
        descriptionLabel.font = .systemFont(ofSize: 20)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        headerStackView.addArrangedSubview(descriptionLabel)
        
        subHeaderStackView.alignment = .center
        subHeaderStackView.distribution = .fillProportionally
        subHeaderStackView.spacing = 10
        subHeaderStackView.axis = .horizontal
        headerStackView.addArrangedSubview(subHeaderStackView)
        
        lowestTempLabel.font = .systemFont(ofSize: 20)
        lowestTempLabel.textAlignment = .center
        subHeaderStackView.addArrangedSubview(lowestTempLabel)
        
        highestTempLabel.font = .systemFont(ofSize: 20)
        highestTempLabel.textAlignment = .center
        subHeaderStackView.addArrangedSubview(highestTempLabel)
        
        //        MARK: - Content
        contentStackView.alignment = .leading
        contentStackView.distribution = .fillProportionally
        contentStackView.axis = .vertical
        contentStackView.spacing = 5
        mainStackView.addArrangedSubview(contentStackView)
        
        feelsLikeStackView.alignment = .leading
        feelsLikeStackView.distribution = .fillProportionally
        feelsLikeStackView.axis = .horizontal
        feelsLikeStackView.spacing = 5
        contentStackView.addArrangedSubview(feelsLikeStackView)
        
        feelsLikeImageView.image = UIImage(systemName: "thermometer")
        feelsLikeStackView.addArrangedSubview(feelsLikeImageView)

        feelsLikeLabel.font = .systemFont(ofSize: 20)
        feelsLikeLabel.textAlignment = .left
        feelsLikeLabel.sizeToFit()
        feelsLikeStackView.addArrangedSubview(feelsLikeLabel)
        
        
        windSpeedStackView.alignment = .leading
        windSpeedStackView.distribution = .fillProportionally
        windSpeedStackView.axis = .horizontal
        windSpeedStackView.spacing = 5
        contentStackView.addArrangedSubview(windSpeedStackView)
        
        windSpeedImageView.image = UIImage(systemName: "wind")
        windSpeedStackView.addArrangedSubview(windSpeedImageView)
        
        windSpeedLabel.font = .systemFont(ofSize: 20)
        windSpeedLabel.textAlignment = .left
        windSpeedLabel.sizeToFit()
        windSpeedStackView.addArrangedSubview(windSpeedLabel)
        
        
        pressureStackView.alignment = .leading
        pressureStackView.distribution = .fillProportionally
        pressureStackView.axis = .horizontal
        pressureStackView.spacing = 5
        contentStackView.addArrangedSubview(pressureStackView)
        
        pressureImageView.image = UIImage(systemName: "barometer")
        pressureStackView.addArrangedSubview(pressureImageView)
        
        pressureLabel.font = .systemFont(ofSize: 20)
        pressureLabel.textAlignment = .left
        pressureLabel.sizeToFit()
        pressureStackView.addArrangedSubview(pressureLabel)
        
        
        humidityStackView.alignment = .leading
        humidityStackView.distribution = .fillProportionally
        humidityStackView.axis = .horizontal
        humidityStackView.spacing = 5
        contentStackView.addArrangedSubview(humidityStackView)
        
        humidityImageView.image = UIImage(systemName: "humidity")
        humidityStackView.addArrangedSubview(humidityImageView)
        
        humidityLabel.font = .systemFont(ofSize: 20)
        humidityLabel.textAlignment = .left
        humidityLabel.sizeToFit()
        humidityStackView.addArrangedSubview(humidityLabel)
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            noLocationLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noLocationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        mainScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainScrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mainStackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true
        
        contentStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.9).isActive = true
    }
    
    func bindData() {
        cancellable = viewModel.$weatherResponse
            .receive(on: DispatchQueue.main)
            .sink { [weak self]  weatherResponse in
                guard let weatherResponse = weatherResponse else {
                    self?.noLocationLabel.isHidden = false
                    self?.mainScrollView.isHidden = true
                    return
                }
                
                self?.noLocationLabel.isHidden = true
                self?.mainScrollView.isHidden = false
                
                self?.cityLabel.text = weatherResponse.cityName ?? ""
                self?.temperatureLabel.text = "\(Int(weatherResponse.weatherData?.temperature ?? 0))º"
                self?.descriptionLabel.text = weatherResponse.weather.first?.description?.capitalized
                self?.lowestTempLabel.text = "L: \(Int(weatherResponse.weatherData?.minTemperature ?? 0))º"
                self?.highestTempLabel.text = "H: \(Int(weatherResponse.weatherData?.maxTemperature ?? 0))º"
                
                
                self?.feelsLikeLabel.text = "Feels like \(Int(weatherResponse.weatherData?.feelsLike ?? 0))ºC"
                self?.windSpeedLabel.text = "Wind speed: \(weatherResponse.wind?.speed ?? 0)Km/h"
                self?.pressureLabel.text = "Pressure: \(Int(weatherResponse.weatherData?.pressure ?? 0))Pa"
                self?.humidityLabel.text = "Humidty: \(Int(weatherResponse.weatherData?.humidity ?? 0))%"
            }
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

