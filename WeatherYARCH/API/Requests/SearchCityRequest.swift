//
//  SearchCityRequest.swift
//  WeatherYARCH
//
//  Created by Филипп on 31/05/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import Foundation

class SearchCityRequest: APIRequest {
    
    typealias Response = [CityStorageModel]

    let endPoint: APIEndPoint
    let parameters: [String : String]
    
    let searchText: String?
    
    init(searchText: String, endPoint: APIEndPoint? = nil, parameters: [String : String] = [:]) {
        self.endPoint = endPoint ?? APIEndPoint(method: "", keyPath: nil)
        self.searchText = searchText
        self.parameters = parameters
    }
    
    required init(_ request: SearchCityRequest) {
        fatalError("You don't need to use it for abstract requests. Just create request subclass object like decorator")
    }
}
