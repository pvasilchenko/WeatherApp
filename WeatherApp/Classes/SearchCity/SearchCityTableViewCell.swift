//
//  SearchCityTableViewCell.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 9/8/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces

class SearchCityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityLabel: UILabel!
    
    func reloadRow(_ autocompletePrediction: GMSAutocompletePrediction) {
        cityLabel.attributedText = autocompletePrediction.attributedFullText
        
    }
    
}
