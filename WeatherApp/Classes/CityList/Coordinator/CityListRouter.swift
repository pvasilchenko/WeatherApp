//
//  CityRouter.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 9/13/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import Foundation
import UIKit

class CityListRouter: NSObject {
    weak var viewController: UIViewController?
    init(vc: UIViewController) {
        super.init()
        self.viewController = vc
    }
}

extension CityListRouter: CityListViewOutput {

    func addCity() {
        let view = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchCityViewController") as! SearchCityViewController
        viewController?.navigationController?.pushViewController(view, animated: true)
    }
    
    func displayCityWeather(for city: CityEntity, _ isCelsius: Bool) {
        let view = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherInfoViewController") as! WeatherInfoViewController
        view.cityData = city
        view.isCelsius = isCelsius
        viewController?.navigationController?.pushViewController(view, animated: true)
    }
}

