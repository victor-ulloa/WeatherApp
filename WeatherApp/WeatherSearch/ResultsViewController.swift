//
//  ResultsViewController.swift
//  WeatherApp
//
//  Created by Host on 2022-11-18.
//

import UIKit
import Combine

class ResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()
    
    var viewModel: WeatherSearchViewModel?
    private var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.frame = CGRect(x: 0, y: view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0, width: self.view.frame.width, height: self.view.frame.height)
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.locations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        if let location = viewModel?.locations?[indexPath.row] {
            cell.textLabel?.text = location.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.index = indexPath.row
    }
    
    func bindData() {
        cancellable = viewModel?.$locations
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self]_ in
            self?.tableView.reloadData()
        })
    }
    
}

