//
//  DailyWeatherEntity+CoreDataProperties.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 9/16/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//
//

import Foundation
import CoreData


extension DailyWeatherEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyWeatherEntity> {
        return NSFetchRequest<DailyWeatherEntity>(entityName: "DailyWeatherEntity")
    }

    @NSManaged public var apparentTemperature: Double
    @NSManaged public var icon: String?
    @NSManaged public var summery: String?
    @NSManaged public var temperatureHight: Double
    @NSManaged public var temperatureLow: Double
    @NSManaged public var time: Int32
    @NSManaged public var windSpeed: Double

}
