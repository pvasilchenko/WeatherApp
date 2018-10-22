//
//  WeatherInfoRouter.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 9/16/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import Foundation
import UIKit

class WeatherInfoRouter {
    weak private var viewController: UIViewController?
    init(vc: UIViewController) {
        self.viewController = vc
    }
}

extension WeatherInfoRouter: WeatherInfoViewOutput {
    
    func dismissViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}



