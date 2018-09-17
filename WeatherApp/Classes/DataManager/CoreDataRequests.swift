//
//  CoreDataRequests.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 9/13/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import GooglePlaces

final class CoreDataRequests {
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveCity(cityName: String, cityInfo: GMSPlace) {
        var city = NSEntityDescription.insertNewObject(forEntityName: "CityEntity",
                                                       into: context) as! CityEntity
        city.setValue(cityName, forKey: Keys.name)
        city.setValue(String(cityInfo.coordinate.latitude), forKey: Keys.latitude)
        city.setValue(String(cityInfo.coordinate.longitude), forKey: Keys.longitude)
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func updateCityWeather(_ city: CityEntity, _ responce: WeatherAPIResponce) {
        if let daily = city.daily {
            city.removeFromDaily(daily)
        }
        var responce = responce
        responce.daily.data += responce.daily.data + responce.daily.data
        var currentWeather = weatherEntity(from: responce.currently)
        var dailyWeather = [DailyWeatherEntity]()
        for weather in responce.daily.data {
            dailyWeather.append(dailyEntity(from: weather))
        }
        city.currently = currentWeather
        city.addToDaily(Set(dailyWeather) as NSSet)
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func weatherEntity(from weather: Weather) -> WeatherEntity {
        var entity = NSEntityDescription.insertNewObject(forEntityName: "WeatherEntity",
                                                          into: context) as! WeatherEntity
        entity.icon = weather.icon
        entity.summary = weather.summary
        entity.temperature = weather.temperature
        entity.time = Int32(weather.time)
        entity.windSpeed = weather.windSpeed
        
        return entity
    }
    
    func dailyEntity(from weather: DailyWeatherData) -> DailyWeatherEntity {
        var entity = NSEntityDescription.insertNewObject(forEntityName: "DailyWeatherEntity",
                                                         into: context) as! DailyWeatherEntity
        entity.icon = weather.icon
        entity.summery = weather.summary
        entity.temperatureLow = weather.temperatureLow
        entity.temperatureHight = weather.temperatureHigh ?? 0.0
        entity.apparentTemperature = weather.apparentTemperatureHigh
        entity.time = Int32(weather.time)
        entity.windSpeed = weather.windSpeed
        
        return entity
    }
    
    func getCityData() -> [CityEntity] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CityEntity")
        var cities = [CityEntity]()
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for city in result as! [CityEntity] {
                cities.append(city)
            }
        } catch {
            print("Failed")
        }
        return cities
    }
    
    func deleteCity(cityForDelete: CityEntity) {
        let cities = getCityData()
        for city in cities {
            if city.value(forKey: "name") as! String == cityForDelete.name {
                try context.delete(city)
            }
        }
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
}
