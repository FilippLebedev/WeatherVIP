//
//  ForecastStorageModel.swift
//  WeatherYARCH
//
//  Created by Филипп on 29/05/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

@objcMembers class ForecastStorageModel: Object, Codable, Copyable, Identified {
    
    dynamic var id: Int = 0 // ID for forecast, not city
    dynamic var date = Date()
    dynamic var temp: Double = Constants.zeroCelsius
    
    var dateString: String?
    var main: ForecastStorageModelMain?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["dateString", "main"]
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "dt"
        case main = "main"
        case dateString = "dt_txt"
    }
    
    init(id: Int, temp: Double, date: Date) {
        self.id = id
        self.temp = temp
        self.date = date
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        main = try container.decode(ForecastStorageModelMain.self, forKey: .main)
        dateString = try container.decode(String.self, forKey: .dateString)
        
        temp = main?.temp ?? Constants.zeroCelsius
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let dateString = dateString, let date = dateFormatter.date(from: dateString) {
            self.date = date
        }
        
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
    
    required init(instance: ForecastStorageModel) {
        self.id = instance.id
        self.date = instance.date
        self.temp = instance.temp
        super.init()
    }
}

struct ForecastStorageModelMain: Codable {
    let temp: Double
}
