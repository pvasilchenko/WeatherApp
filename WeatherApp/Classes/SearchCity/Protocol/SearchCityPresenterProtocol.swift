//
//  SearchCityModule.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 10/21/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import Foundation


protocol SearchCityPresenterProtocol {
    
    func saveCityData(for index: Int)
    
    func getCities(for locationName: String)
}
