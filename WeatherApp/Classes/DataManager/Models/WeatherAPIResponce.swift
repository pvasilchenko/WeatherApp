//
//  WeatherAPIResponce.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 10/21/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

struct WeatherAPIResponce: Codable {
    var currently: Weather
    var daily: DailyWeather
}
