//
//  CityWeatherModule.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 10/21/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import Foundation

protocol WeatherInfoPresenterProtocol {
 
    func getDates(index: Int) -> Date
    
    func setRange(range: WeatherRange)
    
    func viewLoaded()
    
}
