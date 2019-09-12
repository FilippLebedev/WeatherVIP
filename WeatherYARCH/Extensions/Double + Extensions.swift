//
//  Double + Extensions.swift
//  WeatherYARCH
//
//  Created by Filipp Lebedev on 15/05/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import Foundation

extension Double {
    
    var celsius: Double {
        return self - Constants.zeroCelsius
    }
}
