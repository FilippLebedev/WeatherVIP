//
//  Copyable.swift
//  WeatherYARCH
//
//  Created by Филипп on 07/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import Foundation

protocol Copyable {
    init(instance: Self)
}

extension Copyable {
    func duplicate() -> Self {
        return Self.init(instance: self)
    }
}
