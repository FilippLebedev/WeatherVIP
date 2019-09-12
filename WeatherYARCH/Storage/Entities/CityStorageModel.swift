//
//  CityStorageModel.swift
//  WeatherYARCH
//
//  Created by Filipp Lebedev on 15/05/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

@objcMembers class CityStorageModel: Object, Codable, Copyable, Identified {
    
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var latitude: Double = 0
    dynamic var longitude: Double = 0
    dynamic var temp: Double = Constants.zeroCelsius
    
    var coord: CityStorageModelCoord?
    var main: CityStorageModelMain?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["coord", "main"]
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case coord = "coord"
        case main = "main"
    }
    
    init(id: Int, name: String, latitude: Double, longitude: Double, temp: Double) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.temp = temp
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        coord = try container.decode(CityStorageModelCoord.self, forKey: .coord)
        main = try container.decode(CityStorageModelMain.self, forKey: .main)
        
        latitude = coord?.lat ?? 0
        longitude = coord?.lon ?? 0
        temp = main?.temp ?? Constants.zeroCelsius
        
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(instance: CityStorageModel) {
        self.id = instance.id
        self.name = instance.name
        self.latitude = instance.latitude
        self.longitude = instance.longitude
        self.temp = instance.temp
        super.init()
    }
}

struct CityStorageModelCoord: Codable {
    let lat: Double
    let lon: Double
}

struct CityStorageModelMain: Codable {
    let temp: Double
}

