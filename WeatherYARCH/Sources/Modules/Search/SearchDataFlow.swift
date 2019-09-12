//
//  Search module
//  Created by Filipp Lebedev on 05/05/2019.
//

enum Search {
    
    // Search city
    
    enum SearchCity {
        struct Request {
            let searchText: String
        }

        struct Response {
            var result: SearchCityRequestResult
        }

        struct ViewModel {
            var state: ViewControllerState
        }
    }

    enum SearchCityRequestResult {
        case failure(SearchError)
        case success([CityStorageModel])
    }

    enum ViewControllerState {
        case initial
        case loading
        case result([SearchCityModel])
        case emptyResult
        case error(message: String)
    }
    
    // Check city exists in Storage
    
    enum CheckCityExistance {
        struct Request {
            let model: SearchCityModel
        }
        
        struct Response {
            var result: CheckCityExistanceRequestResult
            var viewModel: SearchCityModel
        }
        
        struct ViewModel {
            var model: SearchCityModel
            var isExists: Bool
        }
    }
    
    enum CheckCityExistanceRequestResult {
        case failure(SearchError)
        case success(storageModel: CityStorageModel?)
    }
    
    // Append city into storage
    
    enum AddCity {
        struct Request {
            let model: SearchCityModel
        }
        
        struct Response {
            var result: AddCityRequestResult
        }
        
        struct ViewModel {
            let isSuccess: Bool
        }
    }
    
    enum AddCityRequestResult {
        case failure(SearchError)
        case success
    }
    
    // Common
    
    enum SearchError: Error {
        case searchCityFailed(message: String)
        case checkCityExistanceFailed(message: String)
        case addCityFailed(message: String)
    }
}
