//
//  AbstractService.swift
//  WeatherYARCH
//
//  Created by Filipp Lebedev on 13/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import Foundation

protocol AbstractServiceProtocol: AnyObject {
    var apiClient: APIClient { get }
}

class AbstractService {
    let apiClient: APIClient = OpenWeatherMapAPIClient()
}
