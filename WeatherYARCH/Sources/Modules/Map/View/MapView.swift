//
//  MapView.swift
//  WeatherYARCH
//
//  Created by Filipp Lebedev on 15/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import MapKit

class MapView: MKMapView {
    
    var zoomInCoefficient: Double = 4.0
    var zoomOutCoefficient: Double = 4.0
    
    func zoomIn() {
        zoomIn(coefficient: zoomInCoefficient)
    }
    
    func zoomOut() {
        zoomOut(coefficient: zoomOutCoefficient)
    }
    
    func zoomIn(coefficient: Double) {
        var newRegion = region
        newRegion.span.latitudeDelta = region.span.latitudeDelta / coefficient
        newRegion.span.longitudeDelta = region.span.longitudeDelta / coefficient
        setRegion(newRegion, animated: true)
    }
    
    func zoomOut(coefficient: Double) {
        var newRegion = region
        newRegion.span.latitudeDelta = min((region.span.latitudeDelta) * coefficient, 180.0)
        newRegion.span.longitudeDelta = min((region.span.longitudeDelta) * coefficient, 180.0)
        setRegion(newRegion, animated: true)
    }
}
