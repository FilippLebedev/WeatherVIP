//
//  MapBuilderTests.swift
//  WeatherYARCHTests
//
//  Created by Filipp Lebedev on 17/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import XCTest

@testable import WeatherYARCH

class MapBuilderTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testShouldBuildModuleParts() {
        var builder: MapBuilder!
        
        builder = MapBuilder().set(initialState: .loading)
        
        let navigationController = builder.build() as? UINavigationController
        let controller = navigationController?.viewControllers.first as? MapViewController
        let interactor = controller?.interactor as? MapInteractor
        let presenter = interactor?.presenter as? MapPresenter
        
        XCTAssertNotNil(navigationController, "UINavigationController for Map is nil")
        XCTAssertNotNil(controller, "MapViewController is nil")
        XCTAssertNotNil(interactor, "MapInteractor is nil")
        XCTAssertNotNil(presenter, "MapPresenter is nil")
    }
}
