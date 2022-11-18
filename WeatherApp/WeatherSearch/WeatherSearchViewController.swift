//
//  ViewController.swift
//  WeatherApp
//
//  Created by Host on 2022-11-16.
//

import UIKit
import Combine

class WeatherSearchViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    let searchController = UISearchController(searchResultsController: ResultsViewController())
    let viewModel = WeatherSearchViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

