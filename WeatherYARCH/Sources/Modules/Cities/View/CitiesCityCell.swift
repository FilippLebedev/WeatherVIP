//
//  CitiesCityCell.swift
//  WeatherYARCH
//
//  Created by Филипп on 27/05/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import UIKit

class CitiesCityCell: UITableViewCell {

    @IBOutlet weak private var nameLabel: UILabel!
    
    func configure(cellRepresentable: CitiesCityModel) {
        nameLabel.text = cellRepresentable.name
    }
}
