//
//  SearchCityRouter.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 9/13/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import Foundation
import UIKit

class SearchCityRouter: NSObject {
    weak var viewController: UIViewController?
    init(vc: UIViewController) {
        super.init()
        self.viewController = vc
    }
}

extension SearchCityRouter: SearchCityViewOutput {
    
    func dismissViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}

