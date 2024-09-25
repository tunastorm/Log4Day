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

struct SearchedPlace: Decodable, Identifiable {
    var id = UUID()
    var title: String
    var link: String
    var category: String
    var address: String
    var roadAddress: String
    var mapX: String
    var mapY: String
    
    enum CodingKeys: String, CodingKey {
        case title, link, category, address, roadAddress
        case mapX = "mapx"
        case mapY = "mapy"
    }
}


