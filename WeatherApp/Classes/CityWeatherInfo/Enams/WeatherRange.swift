//
//  WeatherRange.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 10/21/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import Foundation

enum WeatherRange: String, Codable {
    
    case oneWeek
    case twoWeeks
    case monthe
    
    var range: Int {
        switch self {
        case .oneWeek:
            return 7
        case .twoWeeks:
            return 14
        case .monthe:
            return 30
        }
    }
}
