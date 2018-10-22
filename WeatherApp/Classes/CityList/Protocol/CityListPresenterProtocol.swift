//
//  CityListModule.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 10/21/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import Foundation

protocol CityListPresenterProtocol {
    
    func deleteCity(city: CityEntity)
    
    func updateWeather()
}
