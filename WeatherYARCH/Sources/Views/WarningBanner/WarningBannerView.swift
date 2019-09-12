//
//  WarningBannerView.swift
//  WeatherYARCH
//
//  Created by Филипп on 18/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import UIKit

class WarningBannerView: UIView {
    
    var text: String? {
        didSet {
            infoLabel.text = text
        }
    }
    
    lazy private var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    func setup() {
        backgroundColor = UIColor.red.withAlphaComponent(0.8)
        
        addSubview(infoLabel)
        
        infoLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.edges.greaterThanOrEqualToSuperview().offset(16)
        }
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
