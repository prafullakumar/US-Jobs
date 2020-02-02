//
//  Constants.swift
//  Jobs
//
//  Created by prafull kumar on 1/2/20.
//  Copyright © 2020 prafull kumar. All rights reserved.
//

import Foundation

enum APIError: Error, LocalizedError {
    case unknown, apiError(reason: String)

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .apiError(let reason):
            return reason
        }
    }
}

enum Result<A> {
    case success(A)
    case failure(APIError)
}

protocol APIRequestModel {
    var parameters: [String: String] { get }
}
let scheme = "https"
let baseURL = "www.justice.gov"

enum API {
    case get(version: String, route: String, request: APIRequestModel)
    case post(version: String, route: String, request: APIRequestModel)
    case put(version: String, route: String, request: APIRequestModel)
}

enum JobsAPI {
    case detail(request: APIRequestModel)
    
    var api: API {
        switch self {
        case .detail(let request):
            return API.get(version: "v1", route: "vacancy_announcements.json", request: request)
        }
    }
}
