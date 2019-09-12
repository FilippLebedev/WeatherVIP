//
//  TemperatureLabel.swift
//  WeatherYARCH
//
//  Created by Филипп on 28/05/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import UIKit

class TemperatureLabel: UILabel {
    
    var warmColor: UIColor = .green
    var coldColor: UIColor = .blue
    
    var postfix = "℃"
    
    var value: Double = Constants.zeroCelsius {
        didSet {
            updateAppearance()
        }
    }
    
    func updateAppearance() {
        textColor = value > Constants.zeroCelsius + 5 ? warmColor : coldColor
        text = "\(Int(value.celsius))\(postfix)"
    }
}
