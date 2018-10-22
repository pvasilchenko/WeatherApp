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
        dayLabel.text = WeekEnum.allCases.first { $0.positionStringValue ==  dayPosition }?.displayName

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
