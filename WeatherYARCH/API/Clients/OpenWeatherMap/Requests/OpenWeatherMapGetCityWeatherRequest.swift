//
//  OpenWeatherMapGetCityWeatherRequest.swift
//  WeatherYARCH
//
//  Created by Филипп on 17/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import Foundation

class OpenWeatherMapGetCityWeatherRequest: GetCityWeatherRequest {
    
    required init(_ request: GetCityWeatherRequest) {
        let parameters = ["id" : "\(request.cityId)"]
        let endPoint = APIEndPoint(method: "weather", keyPath: nil)
        super.init(cityId: request.cityId, endPoint: endPoint, parameters: parameters)
    }
}
