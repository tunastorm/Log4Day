//
//  GeocodingQuery.swift
//  Log4Day
//
//  Created by 유철원 on 9/25/24.
//

import Foundation

struct GeocodingQuery: Encodable {
    
    var query: String
    var coordinate: String
    var filter: String
    var language: String
    var page: Int // default: 1
    var count: Int // default: 10, 1~100
    
    enum Filter: String {
        case HCODE
        case BCODE
    }
    
}
