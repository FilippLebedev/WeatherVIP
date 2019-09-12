//
//  Map module
//  Created by Filipp Lebedev on 05/05/2019.
//

import UIKit

protocol MapPresentationLogic {
    func presentCities(response: Map.ShowCities.Response)
    func presentWeatherForCity(response: Map.GetWeather.Response)
}

class MapPresenter: MapPresentationLogic {
    weak var viewController: MapDisplayLogic?

    func presentCities(response: Map.ShowCities.Response) {
        var viewModel: Map.ShowCities.ViewModel
        
        switch response.result {
        case let .failure(error):
            viewModel = Map.ShowCities.ViewModel(state: .error(message: error.localizedDescription))
        case let .success(result):
            if result.isEmpty {
                viewModel = Map.ShowCities.ViewModel(state: .emptyResult)
            } else {
                let cities = result.map { MapCityModel(id: $0.id, name: $0.name, latitude: $0.latitude, longitude: $0.longitude, temp: $0.temp) }
                viewModel = Map.ShowCities.ViewModel(state: .result(cities))
            }
        }
        
        viewController?.displayCities(viewModel: viewModel)
    }
    
    func presentWeatherForCity(response: Map.GetWeather.Response) {
        switch response.result {
        case let .failure(error):
            print("Error when get weather: \(error.localizedDescription)")
        case let .success(result):
            let weather = MapWeatherModel(cityId: result.id, temp: result.temp)
            let viewModel = Map.GetWeather.ViewModel(model: weather)
            viewController?.displayWeather(viewModel: viewModel)
        }
    }
}
