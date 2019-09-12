//
//  SearchTableDataSource.swift
//  WeatherYARCH
//
//  Created by Филипп on 04/06/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import UIKit

class SearchTableDataSource: NSObject, UITableViewDataSource {
    
    var representableViewModels: [SearchCityModel]
    
    init(viewModels: [SearchCityModel] = []) {
        representableViewModels = viewModels
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return representableViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithRegistration(type: SearchCityCell.self, indexPath: indexPath)
        guard let viewModel = representableViewModels[safe: indexPath.row] else { return cell }
        cell.configure(cellRepresentable: viewModel)
        return cell
    }
}

