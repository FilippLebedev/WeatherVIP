//
//  ForecastsGroupedByDate.swift
//  WeatherYARCH
//
//  Created by Филипп on 13/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import Foundation

class ForecastsGroupedByDate {
    
    var date: Date
    var forecasts: [ForecastStorageModel] = []
    
    init(date: Date, forecasts: [ForecastStorageModel] = []) {
        self.date = date
        self.forecasts = forecasts
    }
}
