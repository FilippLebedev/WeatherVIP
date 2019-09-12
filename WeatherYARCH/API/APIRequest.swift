//
//  APIRequest.swift
//  WeatherYARCH
//
//  Created by Филипп on 31/05/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import Foundation

protocol APIRequest {
    associatedtype Response: Decodable
    var endPoint: APIEndPoint { get }
    var parameters: [String : String] { get }
    
    init(_ request: Self)
}
