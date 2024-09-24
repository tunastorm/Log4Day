//
//  SearchedPlace.swift
//  Log4Day
//
//  Created by 유철원 on 9/25/24.
//

import Foundation

struct PlaceSearch: Decodable {
    let total: Int
    let start: Int
    var items: [SearchedPlace]
}

struct SearchedPlace: Decodable {
    var title: String
    var link: String
    var category: String
    var address: String
    var roadAddress: String
    var longitude: String
    var latitude: String
    
    enum CodingKeys: String, CodingKey {
        case title, link, category, address, roadAddress
        case longitude = "mapx"
        case latitude = "mapy"
    }
}


