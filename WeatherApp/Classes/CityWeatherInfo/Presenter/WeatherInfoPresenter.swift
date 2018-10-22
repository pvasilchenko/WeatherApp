//
//  CityWeatherPresenter.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 10/21/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import Foundation

class WeatherInfoPresenter: WeatherInfoPresenterProtocol {
    
    weak var viewController: WeatherInfoViewController?
    
    var cityData: CityEntity?
    
    func getDates(index: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = index
        return Calendar.current.date(byAdding: dateComponents, to: Date()) ?? Date()
    }

    func setRange(range: WeatherRange) {
       let weatherInfo = cityData?.daily?.allObjects.prefix(range.range).map { $0 as! DailyWeatherEntity } ?? []
        viewController?.displayWeather(result: weatherInfo)
        
    }

    func viewLoaded() {
        setRange(range: .oneWeek)
        if let cityData = cityData {
            viewController?.displayName(name: cityData.name ?? "")
            if let currentWeather = cityData.currently {
                viewController?.displayCurrentWeather(weather: currentWeather)
            }
        }
    }
}
