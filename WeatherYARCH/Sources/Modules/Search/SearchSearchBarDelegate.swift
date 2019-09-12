//
//  SearchSearchBarDelegate.swift
//  WeatherYARCH
//
//  Created by Филипп on 28/05/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import UIKit

class SearchSearchBarDelegate: NSObject, UISearchBarDelegate {
    
    weak var delegate: SearchViewControllerDelegate?
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.searchCity(text: searchText)
    }
}
