//
//  ServerRequests.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 9/10/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import GooglePlaces
import Alamofire

class APIClient {
    func placeAutocomplete(place: String, complition: @escaping ([GMSAutocompletePrediction], Error?) -> Void) {
        let filter = GMSAutocompleteFilter()
        let placesClient = GMSPlacesClient()
        filter.type = .city
        placesClient.autocompleteQuery(place, bounds: nil, filter: filter, callback: {(results, error) -> Void in
            if let error = error {
                complition([], error)
                return
            }
            if let results = results {
                complition(results, nil)
            }
        })
    }
    
    func getPlaceData(_ placeID: String,  complition: @escaping (GMSPlace?, Error?) -> Void) {
        let placesClient = GMSPlacesClient()
        placesClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                complition(nil, error)
                return
            }
            complition(place, nil)
        })
    }
    
    func getWeather(_ latitude: String, _ longitude: String, callback: @escaping (WeatherAPIResponce?, Error?) -> Void) {
        
        let url = "https://api.darksky.net/forecast/74da64e1ebfb7d1ea0d16ce563db2618/\(latitude),\(longitude)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let apiResponce = try decoder.decode(WeatherAPIResponce.self, from: data)
                    print(response)
                    callback(apiResponce, nil)
                } catch {
                    callback(nil, error)
                }
            case .failure(let error):
                callback(nil, error)
            }
        }
    }
}
