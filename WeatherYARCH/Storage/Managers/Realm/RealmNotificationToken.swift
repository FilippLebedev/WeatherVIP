//
//  RealmNotificationToken.swift
//  WeatherYARCH
//
//  Created by Filipp Lebedev on 16/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmNotificationToken {
    
    var typeString: String
    var notificationToken: NotificationToken
    var predicate: String?
    
    init(typeString: String, notificationToken: NotificationToken, predicate: String? = nil) {
        self.typeString = typeString
        self.notificationToken = notificationToken
        self.predicate = predicate
    }
    
    func invalidate() {
        notificationToken.invalidate()
    }
}

extension RealmNotificationToken: Equatable {
    
    static func == (lhs: RealmNotificationToken, rhs: RealmNotificationToken) -> Bool {
        return lhs.typeString == rhs.typeString &&
            lhs.predicate == rhs.predicate
    }
}
