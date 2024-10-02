//
//  PlaceModel.swift
//  Log4Day
//
//  Created by 유철원 on 10/2/24.
//

import Foundation
import RealmSwift

struct PlaceModel {
    
    var id: ObjectId
    var isVisited: Bool
    var hashtag: String
    var name: String
    var city: String
    var address: String
    var longitude: Double
    var latitude: Double
    var createdAt: Date
    var ofLog: LogModel
    var ofPhoto: [PhotoModel]
    
    init(place: Place) {
        self.id = place.id
        self.isVisited = place.isVisited
        self.hashtag = place.hashtag
        self.name = place.name
        self.city = place.city
        self.address = place.address
        self.longitude = place.longitude
        self.latitude = place.latitude
        self.createdAt = place.createdAt
        self.ofLog = place.ofLog.map{ LogModel(log: $0)}[0]
        self.ofPhoto = place.ofPhoto.map{ PhotoModel(photo: $0)}
    }
    
}
