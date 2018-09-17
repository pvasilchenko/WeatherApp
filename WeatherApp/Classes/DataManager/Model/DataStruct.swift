//
//  DataStruct.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 9/11/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import Foundation

struct CityData {
    var name: String
    var latitude: String
    var longitude: String
}

struct Weather: Codable {
    var summary:String
    var icon:String
    var temperature:Double
    var time: Int
    var apparentTemperature: Double
    var windSpeed: Double
}

struct WeatherAPIResponce: Codable {
    var currently: Weather
    var daily: DailyWeather
}

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

enum WeekEnum: String, Codable {
    
    case monday
    case tuesday
    case wednesdey
    case thursday
    case friday
    case saturday
    case sunday
    
    var displayName: String {
        switch self {
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednesdey:
            return "Wednesdey"
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        case .sunday:
            return "Sunday"
        }
    }
    
    var positionStringValue: String {
        switch self {
        case .monday:
            return "1"
        case .tuesday:
            return "2"
        case .wednesdey:
            return "3"
        case .thursday:
            return "4"
        case .friday:
            return "5"
        case .saturday:
            return "6"
        case .sunday:
            return "7"
        }
    }
}

enum CellID {
    static let searchCityTVCell = "searchCityCell"
    static let cityCell = "cityCell"
    static let weatherInfoCell = "WeatherInfoCell"
}

enum Keys {
    static let name = "name"
    static let latitude = "latitude"
    static let longitude = "longitude"
}
