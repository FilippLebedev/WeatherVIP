//
//  MapButton.swift
//  WeatherYARCH
//
//  Created by Filipp Lebedev on 14/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import UIKit

class MapButton: UIButton {
    
    var appearance: MapButtonAppearance!
    
    func updateAppearance() {
        imageView?.tintColor = appearance.tintColor
        titleLabel?.font = appearance.font
        backgroundColor = appearance.backgroundColor
        
        setTitleColor(appearance.tintColor, for: .normal)
    }
    
    private func setup() {
        setupAppearance()
        setupLayer()
    }
    
    private func setupAppearance() {
        appearance = MapButtonAppearance(mapButton: self)
        updateAppearance()
    }
    
    private func setupLayer() {
        let shadowColor = UIColor.black
        let shadowOffset = CGSize(width: 5, height: 5)
        let shadowOpacity: Float = 0.3
        let shadowRadius: CGFloat = 3.0
        
        cornerRadiusWithShadow(cornerRadius: frame.width / 2, shadowColor: shadowColor, shadowOffset: shadowOffset, shadowOpacity: shadowOpacity, shadowRadius: shadowRadius)
    }
    
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image, for: state)
        imageView?.image = imageView?.image?.withRenderingMode(.alwaysTemplate)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

struct MapButtonAppearance {
    
    private weak var mapButton: MapButton?
    
    init(mapButton: MapButton) {
        self.mapButton = mapButton
    }
    
    var tintColor = UIColor.gray.withAlphaComponent(0.8) {
        didSet {
            mapButton?.updateAppearance()
        }
    }
    
    var backgroundColor = UIColor.white.withAlphaComponent(0.9) {
        didSet {
            mapButton?.updateAppearance()
        }
    }
    
    var font = UIFont.systemFont(ofSize: 30) {
        didSet {
            mapButton?.updateAppearance()
        }
    }
}
