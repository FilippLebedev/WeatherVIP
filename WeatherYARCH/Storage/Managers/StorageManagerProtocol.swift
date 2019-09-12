//
//  StorageManagerProtocol.swift
//  WeatherYARCH
//
//  Created by Filipp Lebedev on 13/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import Foundation

typealias StorageApplicable = Identified & Copyable

protocol StorageManagerProtocol: AnyObject {
    
    // CREATE
    
    func create<T: StorageApplicable>(_ object: T, completion: @escaping (_ success: Bool) -> Void)
    
    // READ
    
    func object<T: StorageApplicable>(type: T.Type, id: UniqueIdentifier, completion: @escaping (T?) -> Void)
    func objects<T: StorageApplicable>(type: T.Type, completion: @escaping ([T]?) -> Void)
    func isObjectExists<T: StorageApplicable>(_ object: T, completion: @escaping (Bool) -> Void)
    func setupObjectsObserver<T: Identified>(type: T.Type, completion: @escaping ([T]?, Error?) -> Void)
    
    // DELETE
    
    func delete<T: StorageApplicable>(_ object: T, completion: @escaping (Bool) -> Void)
    func delete<T>(type: T.Type, id: UniqueIdentifier, completion: @escaping (Bool) -> Void) where T: StorageApplicable
    func removeObservers()
}
