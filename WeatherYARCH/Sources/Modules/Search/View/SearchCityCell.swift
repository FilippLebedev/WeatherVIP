//
//  SearchCityCell.swift
//  WeatherYARCH
//
//  Created by Филипп on 28/05/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import UIKit

class SearchCityCell: UITableViewCell {

    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var coordinatesLabel: UILabel!
    @IBOutlet weak private var tempLabel: TemperatureLabel!
    
    func configure(cellRepresentable: SearchCityModel) {
        nameLabel.text = cellRepresentable.name
        tempLabel.value = cellRepresentable.temp
        coordinatesLabel.text = "Latitude: \(cellRepresentable.latitude) / Longitude: \(cellRepresentable.longitude)"
    }
}
