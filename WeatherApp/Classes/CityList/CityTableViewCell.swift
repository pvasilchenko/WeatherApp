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
        cityNameLabel.text = city.name
        tempLabel.text = "\(String(Int(city.currently?.temperature ?? 0)))°"
        if isCelsius {
            if let temp = city.currently?.temperature {
                tempLabel.text = "\(String(convertToCelsius(from: Int(temp))))°"
            }
        }
    }
}
