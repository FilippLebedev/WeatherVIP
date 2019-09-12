//
//  TableStateManager.swift
//  WeatherYARCH
//
//  Created by Filipp Lebedev on 15/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import UIKit

protocol TableStateManager {
    var tableView: UITableView? { get set }
    
    func setInitialState()
    func setLoadingState()
    func setEmptyState()
    func setResultState()
    func setErrorState(error: String)
}

extension TableStateManager {
    
    func setInitialState() {
        tableView?.backgroundView = UIView()
        tableView?.separatorStyle = .none
    }
    
    func setLoadingState() {
        tableView?.backgroundView = UIView()
        tableView?.separatorStyle = .none
    }
    
    func setEmptyState() {
        tableView?.backgroundView = UIView()
        tableView?.separatorStyle = .none
    }

    func setResultState() {
        tableView?.backgroundView = nil
        tableView?.separatorStyle = .singleLine
    }
    
    func setErrorState(error: String) {
        tableView?.backgroundView = UIView()
        tableView?.separatorStyle = .none
    }
}
