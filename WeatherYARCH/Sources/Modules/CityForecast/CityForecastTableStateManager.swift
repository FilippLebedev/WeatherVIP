//
//  CityForecastTableStateManager.swift
//  WeatherYARCH
//
//  Created by Filipp Lebedev on 15/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import UIKit
import SnapKit

class CityForecastTableStateManager: TableStateManager {
    
    weak var tableView: UITableView?
    
    private let emptyStateView = EmptyStateView()
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    func setLoadingState() {
        tableView?.backgroundView = UIView()
        tableView?.backgroundView?.addSubview(activityIndicator)

        activityIndicator.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.startAnimating()
        tableView?.separatorStyle = .none
    }
    
    func setResultState() {
        tableView?.backgroundView = nil
        tableView?.separatorStyle = .singleLine
    }
    
    func setEmptyState() {
        emptyStateView.text = "Sorry, no forecast"
        tableView?.backgroundView = emptyStateView
        tableView?.separatorStyle = .singleLine
    }
}


