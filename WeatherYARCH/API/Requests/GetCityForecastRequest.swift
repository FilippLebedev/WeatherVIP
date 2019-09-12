//
//  GetCityForecastRequest.swift
//  WeatherYARCH
//
//  Created by Filipp Lebedev on 12/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import Foundation

class GetCityForecastRequest: APIRequest {
    
    typealias Response = [ForecastStorageModel]
    
    let endPoint: APIEndPoint
    let parameters: [String : String]
    
    let cityId: UniqueIdentifier
    
    init(cityId: UniqueIdentifier, endPoint: APIEndPoint? = nil, parameters: [String : String] = [:]) {
        self.endPoint = endPoint ?? APIEndPoint(method: "", keyPath: nil)
        self.cityId = cityId
        self.parameters = ["id" : "\(cityId)"]
    }
    
    required init(_ request: GetCityForecastRequest) {
        fatalError("You don't need to use it for abstract requests. Just create request subclass object like decorator")
    }
}
