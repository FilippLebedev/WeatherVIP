//
//  CityForecastTableDataSource.swift
//  WeatherYARCH
//
//  Created by Филипп on 29/05/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import UIKit

class CityForecastTableDataSource: NSObject, UITableViewDataSource {
    
    var representableViewModels: [CityForecastModel]
    
    init(viewModels: [CityForecastModel] = []) {
        representableViewModels = viewModels
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return representableViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithRegistration(type: CityForecastCell.self, indexPath: indexPath)
        guard let viewModel = representableViewModels[safe: indexPath.row] else { return cell }
        cell.configure(cellRepresentable: viewModel)
        return cell
    }
}
