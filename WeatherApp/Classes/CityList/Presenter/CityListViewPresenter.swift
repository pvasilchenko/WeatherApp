//
//  CityListViewPresenter.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 10/20/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import Foundation

class CityListViewPresenter: CityListPresenterProtocol {
    
    private let request = APIClient()
    private let coreDataRequest = CoreDataService()
    
    weak var viewController: CityListViewController?
    
    func deleteCity(city: CityEntity) {
        coreDataRequest.deleteCity(cityForDelete: city)
    }
    
    func updateWeather() {
        let cities = coreDataRequest.getCityData()
        let dispatchGroup = DispatchGroup()
        for city in cities {
            dispatchGroup.enter()
            request.getWeather(city.latitude ?? "", city.longitude ?? "", callback: { results, error -> Void in
                if let results = results {
                    self.coreDataRequest.updateCityWeather(city, results)
                }
                dispatchGroup.leave()
            })
        }
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            self.viewController?.display(cities: cities)
        })
    }
}
