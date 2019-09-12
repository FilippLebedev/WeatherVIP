//
//  CityForecast module
//  Created by Filipp Levedev on 29/05/2019.
//

enum CityForecast {
    
    enum ShowForecast {
        struct Request {
            var cityId: UniqueIdentifier
        }

        struct Response {
            var result: CityForecastRequestResult
        }

        struct ViewModel {
            var state: ViewControllerState
        }
    }

    enum CityForecastRequestResult {
        case failure(CityForecastError)
        case success([ForecastStorageModel])
    }
    
    enum ViewControllerState {
        case initial(cityId: UniqueIdentifier)
        case loading
        case result([CityForecastModel])
        case emptyResult
        case error(message: String)
    }

    enum CityForecastError: Error {
        case getForecastFailed(message: String)
    }
}
