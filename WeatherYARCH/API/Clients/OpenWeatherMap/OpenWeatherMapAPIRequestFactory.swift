//
//  OpenWeatherMapAPIRequestFactory.swift
//  WeatherYARCH
//
//  Created by Филипп on 17/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import Foundation

class OpenWeatherMapAPIRequestFactory: APIRequestFactory {
    
    func request<T>(_ abstractRequest: T) -> T? where T : APIRequest {
        switch abstractRequest {
        case is SearchCityRequest:
            return OpenWeatherMapSearchCityRequest(abstractRequest as! SearchCityRequest) as? T
        case is GetCityWeatherRequest:
            return OpenWeatherMapGetCityWeatherRequest(abstractRequest as! GetCityWeatherRequest) as? T
        case is GetCityForecastRequest:
            return OpenWeatherMapGetCityForecastRequest(abstractRequest as! GetCityForecastRequest) as? T
        default:
            return nil
        }
    }
}
