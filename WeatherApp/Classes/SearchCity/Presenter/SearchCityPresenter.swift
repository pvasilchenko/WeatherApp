//
//  SearchCityPresenter.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 10/21/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import Foundation
import CoreLocation
import GooglePlaces

class SearchCityPresenter: SearchCityPresenterProtocol {
    
    private let coreDataRequest = CoreDataService()
    private let request = APIClient()
    
    weak var viewController: SearchCityViewController?
    
    private var placesArray = [GMSAutocompletePrediction]() {
        didSet {
            self.viewController?.display(places: self.placesArray)
        }
    }
    
    func saveCityData(for index: Int) {
        let city =  self.placesArray[index].attributedPrimaryText.string
        if let placeID = self.placesArray[index].placeID {
            self.request.getPlaceData(placeID, complition: { place, error -> Void in
                if let place = place {
                    self.coreDataRequest.saveCity(cityName: city, cityInfo: place)
                }
                self.viewController?.onSave()
            })
        }
    }
    
    func getCities(for locationName: String) {
        request.placeAutocomplete(place: locationName, complition: { results, error -> Void in
            if results.count > 0 {
                self.placesArray = results
            }
        })
    }
    
}
