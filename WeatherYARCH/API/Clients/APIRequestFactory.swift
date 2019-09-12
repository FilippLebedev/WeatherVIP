//
//  APIRequestFactory.swift
//  WeatherYARCH
//
//  Created by Филипп on 17/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import Foundation

protocol APIRequestFactory {
    func request<T: APIRequest>(_ abstractRequest: T) -> T?
}
