//
//  RealmService.swift
//  WeatherYARCH
//
//  Created by Филипп on 06/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import Foundation
import RealmSwift

class RealmService: StorageManagerProtocol {

    private var operationQueueWrite = OperationQueue()
    private var dispatchQueueWrite = DispatchQueue(label: "dispatchQueueWrite", qos: .default)
    private var operationQueueRead = OperationQueue()
    private var dispatchQueueRead = DispatchQueue(label: "dispatchQueueRead", qos: .default)
    
    private var notificationTokens = [RealmNotificationToken]()
    
    init() {
        operationQueueWrite.maxConcurrentOperationCount = 1
        operationQueueWrite.underlyingQueue = dispatchQueueWrite
        operationQueueRead.underlyingQueue = dispatchQueueRead
    }
    
    private func isRealmApplicable<T>(_ type: T.Type) -> Bool {
        return (type.self is Object.Type)
    }
    
    func create<T: StorageApplicable>(_ object: T, completion: @escaping (_ success: Bool) -> Void) {
        guard isRealmApplicable(T.self) else {
            completion(false)
            return
        }
        
        operationQueueWrite.addOperation { [weak self] in
            guard let _self = self else {
                completion(false)
                return
            }

            guard let realm = try? Realm() else {
                completion(false)
                return
            }

            try? realm.write {
                realm.add(object.duplicate() as! Object)
            }

            try? realm.commitWrite()

            completion(true)
        }
    }
    
    func delete<T: StorageApplicable>(_ object: T, completion: @escaping (Bool) -> Void) {
        let objectId = object.id
        let type = T.self
        delete(type: type, id: objectId, completion: completion)
    }
    
    func delete<T>(type: T.Type, id: UniqueIdentifier, completion: @escaping (Bool) -> Void) where T: StorageApplicable {
        guard isRealmApplicable(T.self) else {
            completion(false)
            return
        }
        
        operationQueueWrite.addOperation { [weak self] in
            guard let _self = self else {
                completion(false)
                return
            }
            
            guard let realm = try? Realm() else {
                completion(false)
                return
            }
            
            let realmObject = realm.objects(T.self as! Object.Type).filter("id = %@", id)

            if realmObject.count > 0, let objectToDelete = realmObject.first {
                try? realm.write {
                    realm.delete(objectToDelete)
                }
            }
            
            try? realm.commitWrite()
            
            completion(true)
        }
    }
    
    func isObjectExists<T: StorageApplicable>(_ object: T, completion: @escaping (Bool) -> Void) {
        guard isRealmApplicable(T.self) else {
            completion(false)
            return
        }
        
        let objectId = object.id
        
        operationQueueRead.addOperation { [weak self] in
            guard let _self = self else {
                completion(false)
                return
            }
            
            guard let realm = try? Realm() else {
                completion(false)
                return
            }
            
            let realmObject = realm.objects(T.self as! Object.Type).filter("id = %@", objectId)

            if realmObject.count > 0 {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func objects<T: StorageApplicable>(type: T.Type, completion: @escaping ([T]?) -> Void) {
        guard isRealmApplicable(T.self) else {
            completion(nil)
            return
        }
        
        operationQueueRead.addOperation { [weak self] in
            guard let realm = try? Realm() else {
                completion(nil)
                return
            }
            
            let result = realm.objects(T.self as! Object.Type)
            completion(Array(result) as? [T])
        }
    }
    
    func object<T: StorageApplicable>(type: T.Type, id: UniqueIdentifier, completion: @escaping (T?) -> Void) {
        guard isRealmApplicable(T.self) else {
            completion(nil)
            return
        }
        
        operationQueueRead.addOperation { [weak self] in
            guard let realm = try? Realm() else {
                completion(nil)
                return
            }
            
            completion(realm.object(ofType: type as! Object.Type, forPrimaryKey: id) as? T)
        }
    }

    func setupObjectsObserver<T: Identified>(type: T.Type, completion: @escaping ([T]?, Error?) -> Void) {
        guard isRealmApplicable(T.self) else {
            completion(nil, nil)
            return
        }
        
        guard let realm = try? Realm() else {
            completion(nil, nil)
            return
        }
        
        let localObjectsResults = realm.objects(T.self as! Object.Type)
        
        let notificationToken = localObjectsResults.observe() { (changes) in
            switch changes {
            case .initial(let objects), .update(let objects, _, _, _):
                completion(Array(objects) as? [T], nil)
            case .error(let error):
                print(error.localizedDescription)
                break
            }
        }
        
        let realmNotificationToken = RealmNotificationToken(typeString: String(describing: T.self), notificationToken: notificationToken)
        
        let duplicateTokens = self.notificationTokens.filter({ $0 == realmNotificationToken })
        
        for duplicateToken in duplicateTokens {
            duplicateToken.invalidate()
            if let index = self.notificationTokens.firstIndex(where: { $0 == duplicateToken }) {
                self.notificationTokens.remove(at: index)
            }
        }
        
        self.notificationTokens.append(realmNotificationToken)
    }
    
    func removeObservers() {
        for token in notificationTokens {
            token.invalidate()
            if let index = notificationTokens.firstIndex(where: { $0 == token }) {
                notificationTokens.remove(at: index)
            }
        }
    }
}
