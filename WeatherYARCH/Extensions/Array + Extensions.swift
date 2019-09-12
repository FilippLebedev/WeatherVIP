//
//  Array + Extensions.swift
//  WeatherYARCH
//
//  Created by Филипп on 27/05/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
