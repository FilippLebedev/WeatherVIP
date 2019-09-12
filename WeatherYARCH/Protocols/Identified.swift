//
//  Identified.swift
//  WeatherYARCH
//
//  Created by Филипп on 06/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import Foundation

typealias UniqueIdentifier = Int

protocol Identified {
    var id: UniqueIdentifier { get set }
}
