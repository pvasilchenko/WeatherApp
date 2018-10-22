//
//  CelsiumToFaringheit.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 10/22/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//


func convertToCelsius(from fahrenheit: Int) -> Int {
    return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
}
