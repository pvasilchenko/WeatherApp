//
//  ViewController.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 9/7/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces


class SearchCityViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityTableView: UITableView!
    
    let coreDataRequest = CoreDataRequests()
    
    var noResults = false
    
    var output: SearchCityViewOutput?
    
    var placesArray = [GMSAutocompletePrediction]() {
        didSet {
            cityTableView.reloadData()
        }
    }
    
    let request = ServerRequests()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupComponents()
        self.searchBar.becomeFirstResponder()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        output = SearchCityRouter(vc: self)
    }

    func setupComponents() {
        searchBar.keyboardAppearance = .dark
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        output?.dismissViewController()
    }
}

extension SearchCityViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text, !locationString.isEmpty {
            request.placeAutocomplete(place: locationString, complition: { results -> Void in
                if results.count > 0 {
                    self.placesArray = results
                } else {
                    self.noResults = true
                }
            })
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let locationString = searchBar.text, !locationString.isEmpty {
            request.placeAutocomplete(place: locationString, complition: { results -> Void in
                if results.count > 0 {
                    self.noResults = false
                    self.placesArray = results
                } else {
                    self.noResults = true
                }
            })
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
        let city =  self.placesArray[indexPath.row].attributedPrimaryText.string
        if let placeID = self.placesArray[indexPath.row].placeID {
            self.request.getPlaceData(placeID, complition: { place -> Void in
                self.coreDataRequest.saveCity(cityName: city, cityInfo: place)
                self.output?.dismissViewController()
            })
        }
    }
}
