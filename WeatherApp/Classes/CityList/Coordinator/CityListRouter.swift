//
//  CityRouter.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 9/13/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import Foundation
import UIKit

class CityListRouter {
    weak private var viewController: UIViewController?
    init(vc: UIViewController) {
        self.viewController = vc
    }
}

extension CityListRouter: CityListViewOutput {

    func addCity() {
        let view = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchCityViewController") as! SearchCityViewController
        let presenter = SearchCityPresenter()
        presenter.viewController = view
        view.presenter = presenter
        view.output = SearchCityRouter(vc: view)
        viewController?.navigationController?.pushViewController(view, animated: true)
    }
    
    func displayCityWeather(for city: CityEntity, _ isCelsius: Bool) {
        let view = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherInfoViewController") as! WeatherInfoViewController
        let presenter = WeatherInfoPresenter()
        presenter.viewController = view
        view.output = WeatherInfoRouter(vc: view)
        view.presenter = presenter
        presenter.cityData = city
        view.isCelsius = isCelsius
        viewController?.navigationController?.pushViewController(view, animated: true)
    }
}

