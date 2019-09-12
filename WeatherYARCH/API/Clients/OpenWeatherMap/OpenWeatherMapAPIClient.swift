//
//  OpenWeatherMapAPIClient.swift
//  WeatherYARCH
//
//  Created by Филипп on 31/05/2019.
//  Copyright © 2019 Filipp Lebedev. All rights reserved.
//

import Foundation
import Alamofire
import CodableAlamofire

class OpenWeatherMapAPIClient: APIClient {

    let baseURL = "http://api.openweathermap.org/data/2.5/"
    let appID = AppPrivateData.openWeatherMapAPIKey
    
    let requestFactory: APIRequestFactory = OpenWeatherMapAPIRequestFactory()
    
    func request<T>(for abstractRequest: T) -> T where T : APIRequest {
        return requestFactory.request(abstractRequest) ?? abstractRequest
    }
    
    func send<T>(_ request: T, completion: @escaping (Result<T.Response>) -> Void) where T : APIRequest {
        let urlString = absoluteURL(for: request).absoluteString
        typealias ObjectType = T.Response

        Alamofire.request(urlString, method: .get, parameters:request.parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            print("REQUEST: \(response.request?.url?.absoluteString ?? "")")
            
            if let error = response.result.error {
                self.analyzeError(error: error)
                
                if !self.isErrorIgnored(error: error) {
                    completion(.failure(error))
                }
            }
        }
        .responseDecodableObject(keyPath: request.endPoint.keyPath, decoder: JSONDecoder()) { (response: DataResponse<ObjectType>) in
            guard let result = response.result.value else {
                if let error = response.error {
                    print("ERROR DECODING: \(error)")
                }
                return
            }
            print("SUCCESS DECODING")
            completion(.success(result))
        }
    }
    
    func absoluteURL<T>(for request: T) -> URL where T : APIRequest {
        let path = "\(baseURL)\(request.endPoint.method)?appid=\(appID)".replacingOccurrences(of: " ", with: "%20")
        return URL(string: path) ?? URL(string: "")!
    }
    
    func cancelAllRequests() {
        Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
            tasks.forEach { $0.cancel() }
        }
    }
    
    private func analyzeError(error: Error?) {
        if let error = error as? AFError {
            switch error {
            case .invalidURL(let url):
                print("Invalid URL: \(url) - \(error.localizedDescription)")
            case .parameterEncodingFailed(let reason):
                print("Parameter encoding failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
            case .multipartEncodingFailed(let reason):
                print("Multipart encoding failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
            case .responseValidationFailed(let reason):
                print("Response validation failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
                
                switch reason {
                case .dataFileNil, .dataFileReadFailed:
                    print("Downloaded file could not be read")
                case .missingContentType(let acceptableContentTypes):
                    print("Content Type Missing: \(acceptableContentTypes)")
                case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                    print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                case .unacceptableStatusCode(let code):
                    print("Response status code was unacceptable: \(code)")
                }
            case .responseSerializationFailed(let reason):
                print("Response serialization failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
            default:break
            }
            print("Underlying error: \(error.underlyingError)")
        } else if let error = error as? URLError {
            print("URLError occurred: \(error)")
        } else {
            print("Unknown error: \(error)")
        }
    }
    
    private func isErrorIgnored(error: Error?) -> Bool {
        if let error = error as? URLError {
            switch error.code {
            case .cancelled:
                return true
            default:
                return false
            }
        }
        
        return false
    }
}
