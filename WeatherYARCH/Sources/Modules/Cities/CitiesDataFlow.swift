//
//  Cities module
//  Created by Filipp Lebedev on 05/05/2019.
//

enum Cities {
    
    // Get cities
    
    enum ShowCities {
        struct Request {
        }

        struct Response {
            var result: CitiesRequestResult
        }

        struct ViewModel {
            var state: ViewControllerState
        }
    }

    enum CitiesRequestResult {
        case failure(CitiesError)
        case success([CityStorageModel])
    }

    enum ViewControllerState {
        case loading
        case result([CitiesCityModel])
        case emptyResult
        case error(message: String)
    }

    // Delete city
    
    enum DeleteCity {
        struct Request {
            var cityId: UniqueIdentifier
        }
        
        struct Response {
            var result: DeleteCityRequestResult
        }
        
        struct ViewModel {
            var isSuccess: Bool
            var errorMessage: String?
        }
    }
    
    enum DeleteCityRequestResult {
        case failure(CitiesError)
        case success
    }
    
    // Common
    
    enum CitiesError: Error {
        case getCitiesFailed(message: String)
        case deleteCityFailed(message: String)
    }
}
