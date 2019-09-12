//
//  AbstractDataStore.swift
//  WeatherYARCH
//
//  Created by Filipp Lebedev on 14/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import Foundation

protocol AbstractDataStoreProtocol: AnyObject {
    var storageManager: StorageManagerProtocol { get }
}

class AbstractDataStore: AbstractDataStoreProtocol {
    let storageManager: StorageManagerProtocol = RealmService()
    
    deinit {
        storageManager.removeObservers()
        print("Storage observers removed for: \(String(describing: self))")
    }
}
