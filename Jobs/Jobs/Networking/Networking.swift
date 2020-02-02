//
//  Networking.swift
//  Jobs
//
//  Created by prafull kumar on 1/2/20.
//  Copyright © 2020 prafull kumar. All rights reserved.
//

import Foundation
import Combine


class Networking {
    
    static let shared = Networking()
    
    func fetch(api: API) throws -> AnyPublisher<Data, APIError> {
        guard let request = getURLRequest(api: api) else {
            throw APIError.apiError(reason: "invalid URL")
        }

        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw APIError.unknown
                }
                return data
            }
            .mapError { error in
                if let error = error as? APIError {
                    return error
                } else {
                    return APIError.apiError(reason: error.localizedDescription)
                }
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    private func getURLRequest(api: API) -> URLRequest? {
        switch api {
        case .get(let version,let route, let request):
            var urlComponents = URLComponents()
            urlComponents.scheme = scheme
            urlComponents.host = baseURL
            urlComponents.path = "/" + "api" + "/" + version + "/" + route
            urlComponents.queryItems = []
            for parameter in request.parameters {
                urlComponents.queryItems?.append(URLQueryItem(name: parameter.key, value: parameter.value))
            }
            if let url = urlComponents.url  {
                return URLRequest(url: url)
            }
        default:
            break
            //handle other case when needed
        }
        
        return nil
    }
}
