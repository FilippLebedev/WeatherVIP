//
//  AppDelegate.swift
//  WeatherYARCH
//
//  Created by Filipp Lebedev on 04/05/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupRealmMigrations()
        setupNavigationBar()
        setupInitialViewController()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
    
    private func setupNavigationBar() {
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
    private func setupInitialViewController() {
        let initialVC = MapBuilder().set(initialState: .loading).build()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialVC
        self.window?.makeKeyAndVisible()
    }
    
    private func setupRealmMigrations() {
        let migrationBlock: MigrationBlock = { migration, oldSchemaVersion in }
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 2, migrationBlock: migrationBlock)
        let _ = try! Realm()
    }
}

