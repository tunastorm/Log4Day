//
//  NetworkRouter.swift
//  Log4Day
//
//  Created by 유철원 on 9/25/24.
//

import Foundation
import Alamofire

enum NetworkRouter: URLRequestConvertible {
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: "")!
        return URLRequest(url: url)
    }
    
}
