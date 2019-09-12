//
//  CitiesTableStateManager.swift
//  WeatherYARCH
//
//  Created by Filipp Lebedev on 15/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import UIKit

class CitiesTableStateManager: TableStateManager {
    
    weak var tableView: UITableView?
    
    private let emptyStateView = EmptyStateView()
    
    func setEmptyState() {
        emptyStateView.text = "Saved cities will be displayed here\nAt first go to Search"
        tableView?.backgroundView = emptyStateView
        tableView?.separatorStyle = .none
    }
    
    func setResultState() {
        tableView?.backgroundView = nil
        tableView?.separatorStyle = .singleLine
    }
}

