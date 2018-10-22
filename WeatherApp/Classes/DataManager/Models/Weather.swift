//
//  Weather.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 10/21/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

struct Weather: Codable {
    var summary:String
    var icon:String
    var temperature:Double
    var time: Int
    var apparentTemperature: Double
    var windSpeed: Double
}
