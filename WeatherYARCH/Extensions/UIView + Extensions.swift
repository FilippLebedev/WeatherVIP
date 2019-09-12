//
//  UIView + Extensions.swift
//  WeatherYARCH
//
//  Created by Filipp Lebedev on 15/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import UIKit

extension UIView {
    
    func cornerRadiusWithShadow(cornerRadius: CGFloat, shadowColor: UIColor, shadowOffset: CGSize, shadowOpacity: Float, shadowRadius: CGFloat) {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
    }
}
