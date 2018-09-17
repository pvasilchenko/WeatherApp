//
//  CityCollectionViewCell.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 9/11/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    
    func reloadRow(_ city: CityEntity, _ isCelsius: Bool) {
        cityNameLabel.text = city.value(forKey: Keys.name) as! String
        tempLabel.text = "\(String(Int(city.currently?.temperature ?? 0)))°"
        if isCelsius {
            if let temp = city.currently?.temperature {
                tempLabel.text = "\(String(convertToCelsius(from: Int(temp))))°"
            }
        }
    }
    
    func convertToCelsius(from fahrenheit: Int) -> Int {
        return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
    }
    
}
