//
//  Search module
//  Created by Filipp Lebedev on 05/05/2019.
//

import UIKit

protocol SearchPresentationLogic {
    func presentCities(response: Search.SearchCity.Response)
    func presentCityExistance(response: Search.CheckCityExistance.Response)
    func presentCityAddResult(response: Search.AddCity.Response)
}

class SearchPresenter: SearchPresentationLogic {
    weak var viewController: SearchDisplayLogic?

    func presentCities(response: Search.SearchCity.Response) {
        var viewModel: Search.SearchCity.ViewModel
        
        switch response.result {
        case let .failure(error):
            viewModel = Search.SearchCity.ViewModel(state: .error(message: error.localizedDescription))
        case let .success(result):
            if result.isEmpty {
                viewModel = Search.SearchCity.ViewModel(state: .emptyResult)
            } else {
                let cities = result.map { SearchCityModel(id: $0.id, name: $0.name, latitude: $0.latitude, longitude: $0.longitude, temp: $0.temp) }
                viewModel = Search.SearchCity.ViewModel(state: .result(cities))
            }
        }
        
        viewController?.displayCities(viewModel: viewModel)
    }
    
    func presentCityExistance(response: Search.CheckCityExistance.Response) {
        var viewModel: Search.CheckCityExistance.ViewModel
        
        switch response.result {
        case let .failure(error):
            viewModel = Search.CheckCityExistance.ViewModel(model: response.viewModel, isExists: false)
        case let .success(result):
            if let result = result {
                viewModel = Search.CheckCityExistance.ViewModel(model: response.viewModel, isExists: true)
            } else {
                viewModel = Search.CheckCityExistance.ViewModel(model: response.viewModel, isExists: false)
            }
        }
        
        viewController?.displayCityExistance(viewModel: viewModel)
    }
    
    func presentCityAddResult(response: Search.AddCity.Response) {
        var viewModel: Search.AddCity.ViewModel
        
        switch response.result {
        case let .failure(error):
            viewModel = Search.AddCity.ViewModel(isSuccess: false)
        case let .success:
            viewModel = Search.AddCity.ViewModel(isSuccess: true)
        }
        
        viewController?.displayCityAddResult(viewModel: viewModel)
    }
}
