//
//  CityEntity+CoreDataProperties.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 9/16/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//
//

import Foundation
import CoreData


extension CityEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityEntity> {
        return NSFetchRequest<CityEntity>(entityName: "CityEntity")
    }

    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var name: String?
    @NSManaged public var currently: WeatherEntity?
    @NSManaged public var daily: NSSet?

}

// MARK: Generated accessors for daily
extension CityEntity {

    @objc(addDailyObject:)
    @NSManaged public func addToDaily(_ value: DailyWeatherEntity)

    @objc(removeDailyObject:)
    @NSManaged public func removeFromDaily(_ value: DailyWeatherEntity)

    @objc(addDaily:)
    @NSManaged public func addToDaily(_ values: NSSet)

    @objc(removeDaily:)
    @NSManaged public func removeFromDaily(_ values: NSSet)

}
