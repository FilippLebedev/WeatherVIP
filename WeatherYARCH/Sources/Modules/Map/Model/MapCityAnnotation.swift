//
//  MapCityAnnotation.swift
//  WeatherYARCH
//
//  Created by Filipp Lebedev on 15/05/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import Foundation
import MapKit

class MapCityAnnotation: NSObject, MKAnnotation {
    
    var title: String?
    let coordinate: CLLocationCoordinate2D
    
    let cityId: UniqueIdentifier
    let name: String
    
    var temp: Double = Constants.zeroCelsius {
        didSet {
            self.title = "\(name) (\(Int(temp.celsius))℃)"
        }
    }
    
    init(cityId: UniqueIdentifier, name: String, coordinate: CLLocationCoordinate2D) {
        self.cityId = cityId
        self.name = name
        self.title = "\(name) (...)"
        self.coordinate = coordinate
        super.init()
    }
}
