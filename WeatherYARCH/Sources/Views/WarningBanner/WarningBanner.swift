//
//  WarningBanner.swift
//  WeatherYARCH
//
//  Created by Filipp Lebedev on 18/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import UIKit

class WarningBanner {
    
    private weak var owner: UIView?
    private var timer: Timer?
    private let warningBannerView = WarningBannerView()
    
    init(for owner: UIView) {
        self.owner = owner
    }
    
    func present(_ message: String, time: TimeInterval? = nil) {
        setupTimer(time: time)
        presentView(message)
    }
    
    func dismiss() {
        invalidateTimer()
        hideView()
    }
    
    private func presentView(_ message: String) {
        warningBannerView.removeFromSuperview()
        warningBannerView.alpha = 0
        
        guard let owner = owner else { return }
        
        warningBannerView.text = message
        
        owner.addSubview(warningBannerView)
        owner.bringSubviewToFront(warningBannerView)
        
        warningBannerView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        UIView.animate(withDuration: 1) {
            self.warningBannerView.alpha = 1
        }
    }
    
    private func hideView() {
        UIView.animate(withDuration: 1, animations: {
            self.warningBannerView.alpha = 0
        }, completion: { _ in
            self.warningBannerView.removeFromSuperview()
        })
    }
    
    private func setupTimer(time: TimeInterval?) {
        invalidateTimer()
        
        if let time = time {
            timer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: false)
        }
    }
    
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func fireTimer() {
        dismiss()
    }
}
