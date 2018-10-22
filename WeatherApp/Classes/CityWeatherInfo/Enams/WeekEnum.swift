//
//  WeekEnum.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 10/21/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import Foundation

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
    static var allCases:[WeekEnum] {
        
        return [WeekEnum.monday, WeekEnum.thursday, WeekEnum.wednesdey, WeekEnum.tuesday, WeekEnum.friday, WeekEnum.saturday, WeekEnum.sunday]
        
    }
}
