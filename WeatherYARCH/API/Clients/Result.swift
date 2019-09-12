//
//  Result.swift
//  WeatherYARCH
//
//  Created by Filipp Lebedev on 05/05/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
