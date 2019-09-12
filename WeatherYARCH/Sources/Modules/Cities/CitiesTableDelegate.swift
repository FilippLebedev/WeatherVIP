//
//  CitiesTableDelegate.swift
//  WeatherYARCH
//
//  Created by Филипп on 27/05/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import UIKit

class CitiesTableDelegate: NSObject, UITableViewDelegate {
    
    weak var delegate: CitiesViewControllerDelegate?
    
    var representableViewModels: [CitiesCityModel]
    
    init(viewModels: [CitiesCityModel] = []) {
        representableViewModels = viewModels
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }
        
        guard let viewModel = representableViewModels[safe: indexPath.row] else { return }
        delegate?.selectCity(id: viewModel.id)
    }
}
