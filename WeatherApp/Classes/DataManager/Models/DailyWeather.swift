//
//  DailyWeather.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 10/21/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

struct DailyWeather: Codable {
    var data: [DailyWeatherData]
}

struct DailyWeatherData: Codable {
    var summary:String
    var temperatureLow: Double
    var temperatureHigh: Double?
    var icon:String
    var time: Int
    var apparentTemperatureHigh: Double
    var windSpeed: Double
}
