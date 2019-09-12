//
//  CityForecastCell.swift
//  WeatherYARCH
//
//  Created by Филипп on 29/05/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import UIKit

class CityForecastCell: UITableViewCell {

    @IBOutlet weak private var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    var date = Date() {
        didSet {
            let dateFormatterDay = DateFormatter()
            dateFormatterDay.dateFormat = "EEEE"
            dayLabel.text = dateFormatterDay.string(from: date)
            
            let dateFormatterDate = DateFormatter()
            dateFormatterDate.dateFormat = "MMM d"
            dateLabel.text = dateFormatterDate.string(from: date)
        }
    }
    
    var temp: (minimal: Double, maximal: Double) = (Constants.zeroCelsius, Constants.zeroCelsius) {
        didSet {
            tempLabel.text = "\(Int(temp.minimal.celsius)) .. \(Int(temp.maximal.celsius))"
        }
    }
    
    func configure(cellRepresentable: CityForecastModel) {
        date = cellRepresentable.date
        temp = (minimal: cellRepresentable.minimalTemp, maximal: cellRepresentable.maximalTemp)
    }
}
