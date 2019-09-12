//
//  CityForecast module
//  Created by Filipp Levedev on 29/05/2019.
//

import UIKit

protocol CityForecastPresentationLogic {
    func presentForecast(response: CityForecast.ShowForecast.Response)
}

class CityForecastPresenter: CityForecastPresentationLogic {
    weak var viewController: CityForecastDisplayLogic?

    func presentForecast(response: CityForecast.ShowForecast.Response) {
        var viewModel: CityForecast.ShowForecast.ViewModel
        
        switch response.result {
        case let .failure(error):
            viewModel = CityForecast.ShowForecast.ViewModel(state: .error(message: error.localizedDescription))
        case let .success(result):
            if result.isEmpty {
                viewModel = CityForecast.ShowForecast.ViewModel(state: .emptyResult)
            } else {
                viewModel = forecastViewModel(from: response)
            }
        }
        
        viewController?.displayForecast(viewModel: viewModel)
    }
    
    private func forecastViewModel(from forecast: CityForecast.ShowForecast.Response) -> CityForecast.ShowForecast.ViewModel {
        switch forecast.result {
        case let .success(result):
            
            let groupedData = Dictionary(grouping: result, by: { Calendar.current.startOfDay(for: $0.date) })
            let forecastGroups = groupedData.map{ ForecastsGroupedByDate(date: $0.key, forecasts: $0.value) }
            let forecastGroupsSorted = forecastGroups.sorted(by: { $0.date < $1.date })
            let forecastViewModels = forecastGroupsSorted.map { CityForecastModel(date: $0.date, minimalTemp: minimalTemp(in: $0.forecasts), maximalTemp: maximalTemp(in: $0.forecasts)) }
            
            return CityForecast.ShowForecast.ViewModel(state: .result(forecastViewModels))
            
        default:
            break
        }
        
        return CityForecast.ShowForecast.ViewModel(state: .emptyResult)
    }
    
    private func minimalTemp(in forecasts: [ForecastStorageModel]) -> Double {
        return forecasts.sorted(by: { $0.temp < $1.temp }).first?.temp ?? Constants.zeroCelsius
    }
    
    private func maximalTemp(in forecasts: [ForecastStorageModel]) -> Double {
        return forecasts.sorted(by: { $0.temp > $1.temp }).first?.temp ?? Constants.zeroCelsius
    }
}
