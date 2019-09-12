//
//  SearchTableStateManager.swift
//  WeatherYARCH
//
//  Created by Filipp Lebedev on 15/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import UIKit

class SearchTableStateManager: TableStateManager {
    
    weak var tableView: UITableView?
    
    private let emptyStateView = EmptyStateView()
    
    func setEmptyState() {
        emptyStateView.text = "Not found"
        tableView?.backgroundView = emptyStateView
        tableView?.separatorStyle = .none
    }
    
    func setInitialState() {
        emptyStateView.text = "Enter the name of the city for search\nPlease, use English\n\nIf you got no results check API availability (openweathermap.org/current). Maybe you need to turn VPN on"
        tableView?.backgroundView = emptyStateView
        tableView?.separatorStyle = .none
    }
    
    func setResultState() {
        tableView?.backgroundView = nil
        tableView?.separatorStyle = .singleLine
    }
}
