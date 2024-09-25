//
//  SearchPlaceQuery.swift
//  Log4Day
//
//  Created by 유철원 on 9/25/24.
//

import Foundation


struct SearchPlaceQuery: Encodable {

    var query: String
    var display = 5
    var start = 1
    var sort: String
    
    enum Sort: String {
        case random
        case comment
    }
}
