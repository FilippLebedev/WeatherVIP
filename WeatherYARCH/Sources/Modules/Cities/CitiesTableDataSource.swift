//
//  CitiesTableDataSource.swift
//  WeatherYARCH
//
//  Created by Филипп on 27/05/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import UIKit

class CitiesTableDataSource: NSObject, UITableViewDataSource {
    
    weak var delegate: CitiesViewControllerDelegate?
    
    var representableViewModels: [CitiesCityModel]
    
    init(viewModels: [CitiesCityModel] = []) {
        representableViewModels = viewModels
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return representableViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithRegistration(type: CitiesCityCell.self, indexPath: indexPath)
        guard let viewModel = representableViewModels[safe: indexPath.row] else { return cell }
        cell.configure(cellRepresentable: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let viewModel = representableViewModels[safe: indexPath.row] else { return }
            delegate?.deleteCity(id: viewModel.id)
        }
    }
}
