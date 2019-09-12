//
//  OpenWeatherMapSearchCityRequest.swift
//  WeatherYARCH
//
//  Created by Филипп on 17/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import Foundation

class OpenWeatherMapSearchCityRequest: SearchCityRequest {
    
    required init(_ request: SearchCityRequest) {
        let parameters = ["type" : "like", "q" : request.searchText ?? ""]
        let endPoint = APIEndPoint(method: "find", keyPath: "list")
        super.init(searchText: request.searchText ?? "", endPoint: endPoint, parameters: parameters)
    }
}
