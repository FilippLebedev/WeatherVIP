//
//  WeatherStorageModel.swift
//  WeatherYARCH
//
//  Created by Филипп on 29/05/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

@objcMembers class WeatherStorageModel: Object, Codable, Copyable, Identified {
    
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var temp: Double = Constants.zeroCelsius
    
    var main: WeatherStorageModelMain?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["main"]
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case main = "main"
    }
    
    init(id: Int, name: String, temp: Double) {
        self.id = id
        self.name = name
        self.temp = temp
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        main = try container.decode(WeatherStorageModelMain.self, forKey: .main)
        
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
    
    required init(instance: WeatherStorageModel) {
        self.id = instance.id
        self.name = instance.name
        self.temp = instance.temp
        super.init()
    }
}

struct WeatherStorageModelMain: Codable {
    let temp: Double
}
