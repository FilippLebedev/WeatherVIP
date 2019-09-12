//
//  City module
//  Created by Filipp Lebedev on 05/05/2019.
//

import UIKit

protocol CityPresentationLogic {
    func presentWeather(response: City.ShowWeather.Response)
}

class CityPresenter: CityPresentationLogic {
    weak var viewController: CityDisplayLogic?

    func presentWeather(response: City.ShowWeather.Response) {
        var viewModel: City.ShowWeather.ViewModel
        
        switch response.result {
        case let .failure(error):
            viewModel = City.ShowWeather.ViewModel(state: .error(message: error.localizedDescription))
        case let .success(result):
            let weather = CityWeatherModel(name: result.name, temp: result.temp)
            viewModel = City.ShowWeather.ViewModel(state: .result(weather))
        }
        
        viewController?.displayWeather(viewModel: viewModel)
    }
}
