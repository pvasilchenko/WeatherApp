//
//  WeatherEntity+CoreDataProperties.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 9/16/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//
//

import Foundation
import CoreData


extension WeatherEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherEntity> {
        return NSFetchRequest<WeatherEntity>(entityName: "WeatherEntity")
    }

    @NSManaged public var apparentTemperature: Double
    @NSManaged public var icon: String?
    @NSManaged public var summary: String?
    @NSManaged public var temperature: Double
    @NSManaged public var time: Int32
    @NSManaged public var windSpeed: Double

}
