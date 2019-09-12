//
//  APIClient.swift
//  WeatherYARCH
//
//  Created by Филипп on 31/05/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import Foundation

typealias ResultCallback<Value> = (Result<Value>) -> Void

protocol APIClient: AnyObject {
    var requestFactory: APIRequestFactory { get }
    
    func request<T>(for abstractRequest: T) -> T where T : APIRequest
    func send<T: APIRequest>(_ request: T, completion: @escaping ResultCallback<T.Response>)
    func absoluteURL<T: APIRequest>(for request: T) -> URL
    func cancelAllRequests()
}
