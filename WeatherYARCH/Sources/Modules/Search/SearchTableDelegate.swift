//
//  SearchTableDelegate.swift
//  WeatherYARCH
//
//  Created by Филипп on 04/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import UIKit

class SearchTableDelegate: NSObject, UITableViewDelegate {
    
    weak var delegate: SearchViewControllerDelegate?
    
    var representableViewModels: [SearchCityModel]
    
    init(viewModels: [SearchCityModel] = []) {
        representableViewModels = viewModels
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }
        
        guard let viewModel = representableViewModels[safe: indexPath.row] else { return }
        delegate?.selectCity(model: viewModel)
    }
}

