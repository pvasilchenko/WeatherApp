//
//  CityListViewOutput.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 9/13/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import Foundation

protocol CityListViewOutput {
    
    func addCity()
    
    func displayCityWeather(for city: CityEntity, _ isCelsius: Bool)
    
}
