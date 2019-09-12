//
//  City module
//  Created by Filipp Lebedev on 05/05/2019.
//

protocol CityBusinessLogic {
    func fetchWeather(request: City.ShowWeather.Request)
}

class CityInteractor: CityBusinessLogic {
    let presenter: CityPresentationLogic
    let provider: CityProviderProtocol

    init(presenter: CityPresentationLogic, provider: CityProviderProtocol = CityProvider()) {
        self.presenter = presenter
        self.provider = provider
    }
    
    func fetchWeather(request: City.ShowWeather.Request) {
        provider.getWeather(cityId: request.cityId) { (items, error) in
            let result: City.ShowWeatherRequestResult
            if let items = items {
                result = .success(items)
            } else if let error = error {
                result = .failure(.getWeatherFailed(message: error.localizedDescription))
            } else {
                result = .failure(.getWeatherFailed(message: "Empty data fetched for weather"))
            }
            self.presenter.presentWeather(response: City.ShowWeather.Response(result: result))
        }
    }
}
