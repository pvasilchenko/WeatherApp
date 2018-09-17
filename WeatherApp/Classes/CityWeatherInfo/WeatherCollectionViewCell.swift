//
//  WeatherCollectionViewCell.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 9/16/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import Foundation
import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
  
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    func setupCell(from weather: DailyWeatherEntity, and day: Date, _ isCelsius: Bool) {
        let dayPosition = String(Calendar.current.component(.weekday, from: day))
        let daysArray:[WeekEnum?] = [WeekEnum.monday, WeekEnum.thursday, WeekEnum.wednesdey, WeekEnum.tuesday, WeekEnum.friday, WeekEnum.saturday, WeekEnum.sunday]
        for weekDay in daysArray {
            if weekDay?.positionStringValue == dayPosition {
                dayLabel.text = weekDay?.displayName
            }
        }
        
        if isCelsius {
            weatherLabel.text  = String(convertToCelsius(from: Int(weather.apparentTemperature))) + "°"
        } else {
            weatherLabel.text  = String(Int(weather.apparentTemperature)) + "°"
        }
        if let icon = weather.icon {
            weatherImageView.image = UIImage(named: icon)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? UIColor.red : UIColor.black
        }
    }
}


func convertToCelsius(from fahrenheit: Int) -> Int {
    return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
}
