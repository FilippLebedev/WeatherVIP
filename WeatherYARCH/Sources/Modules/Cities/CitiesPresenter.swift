//
//  Cities module
//  Created by Filipp Lebedev on 05/05/2019.
//

import UIKit

protocol CitiesPresentationLogic {
    func presentCities(response: Cities.ShowCities.Response)
    func presentCityDeletion(response: Cities.DeleteCity.Response)
}

class CitiesPresenter: CitiesPresentationLogic {
    weak var viewController: CitiesDisplayLogic?

    func presentCities(response: Cities.ShowCities.Response) {
        var viewModel: Cities.ShowCities.ViewModel
        
        switch response.result {
        case let .failure(error):
            viewModel = Cities.ShowCities.ViewModel(state: .error(message: error.localizedDescription))
        case let .success(result):
            if result.isEmpty {
                viewModel = Cities.ShowCities.ViewModel(state: .emptyResult)
            } else {
                let cities = result.map { CitiesCityModel(id: $0.id, name: $0.name) }
                viewModel = Cities.ShowCities.ViewModel(state: .result(cities))
            }
        }
        
        viewController?.displayCities(viewModel: viewModel)
    }
    
    func presentCityDeletion(response: Cities.DeleteCity.Response) {
        var viewModel: Cities.DeleteCity.ViewModel
        
        switch response.result {
        case let .failure(error):
            viewModel = Cities.DeleteCity.ViewModel(isSuccess: false, errorMessage: error.localizedDescription)
        case .success:
            viewModel = Cities.DeleteCity.ViewModel(isSuccess: true, errorMessage: nil)
        }
        
        viewController?.displayCityDeletion(viewModel: viewModel)
    }
}
