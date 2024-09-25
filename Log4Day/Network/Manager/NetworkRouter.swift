//
//  NetworkRouter.swift
//  Log4Day
//
//  Created by 유철원 on 9/25/24.
//

import Foundation
import Alamofire


enum NetworkRouter {
    case searchPlace(query: SearchPlaceQuery)
}


extension NetworkRouter: TargetType {
    
    var baseURL: String {
        switch self {
        case .searchPlace:
            return APIConstants.Search.baseURL + APIConstants.Search.version
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .searchPlace:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .searchPlace:
            return APIConstants.Search.place
        }
    }
    
    var headers: Alamofire.HTTPHeaders {
        switch self {
        case .searchPlace:
            return APIConstants.Search.baseHeaders
        }
    }
    
    var body: Data? {
        switch self {
        default: nil
        }
    }
    
    var parameters: (any Encodable)? {
        switch self {
        case .searchPlace(let query):
            return query
        }
    }
    
    var encoder: any Alamofire.ParameterEncoder {
        return URLEncodedFormParameterEncoder.default
    }
    
}
