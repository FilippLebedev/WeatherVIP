//
//  CityForecast module
//  Created by Filipp Levedev on 29/05/2019.
//

protocol CityForecastBusinessLogic {
    func fetchForecast(request: CityForecast.ShowForecast.Request)
}

class CityForecastInteractor: CityForecastBusinessLogic {
    let presenter: CityForecastPresentationLogic
    let provider: CityForecastProviderProtocol

    init(presenter: CityForecastPresentationLogic, provider: CityForecastProviderProtocol = CityForecastProvider()) {
        self.presenter = presenter
        self.provider = provider
    }
    
    func fetchForecast(request: CityForecast.ShowForecast.Request) {
        provider.getForecast(cityId: request.cityId) { (items, error) in
            let result: CityForecast.CityForecastRequestResult
            if let items = items {
                result = .success(items)
            } else if let error = error {
                result = .failure(.getForecastFailed(message: error.localizedDescription))
            } else {
                result = .failure(.getForecastFailed(message: "Empty data fetched for forecast"))
            }
            self.presenter.presentForecast(response: CityForecast.ShowForecast.Response(result: result))
        }
    }
}
