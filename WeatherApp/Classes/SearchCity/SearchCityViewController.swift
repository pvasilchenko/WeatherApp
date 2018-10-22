//
//  ViewController.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 9/7/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import UIKit
import GooglePlaces

class SearchCityViewController: UIViewController {
    
    private enum CellID {
        static let searchCityTVCell = "searchCityCell"
    }
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var cityTableView: UITableView!
    
    var presenter: SearchCityPresenterProtocol?
    
    var output: SearchCityViewOutput?
    
    private var placesArray = [GMSAutocompletePrediction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupComponents()
        self.searchBar.becomeFirstResponder()
    }

    private func setupComponents() {
        searchBar.keyboardAppearance = .dark
    }
    
    @IBAction private func cancelButtonTapped(_ sender: Any) {
        output?.dismissViewController()
    }
    
    func display(places: [GMSAutocompletePrediction]) {
        self.placesArray = places
        self.cityTableView.reloadData()
    }
    
    func onSave() {
        self.output?.dismissViewController()
    }
}

extension SearchCityViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationName = searchBar.text, !locationName.isEmpty {
            presenter?.getCities(for: locationName)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let locationName = searchBar.text, !locationName.isEmpty {
            presenter?.getCities(for: locationName)
        } else {
            self.placesArray.removeAll()
        }
    }
}


extension SearchCityViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchCityTableViewCell
        let place = self.placesArray[indexPath.row]
        cell = tableView.dequeueReusableCell(withIdentifier: CellID.searchCityTVCell, for: indexPath) as! SearchCityTableViewCell
        cell.reloadRow(place)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.saveCityData(for: indexPath.row)
    }
}
