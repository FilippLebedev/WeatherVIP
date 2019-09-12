//
//  OpenWeatherMapGetCityForecastRequest.swift
//  WeatherYARCH
//
//  Created by Филипп on 17/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import Foundation

class OpenWeatherMapGetCityForecastRequest: GetCityForecastRequest {
    
    required init(_ request: GetCityForecastRequest) {
        let parameters = ["id" : "\(request.cityId)"]
        let endPoint = APIEndPoint(method: "forecast", keyPath: "list")
        super.init(cityId: request.cityId, endPoint: endPoint, parameters: parameters)
    }
}
