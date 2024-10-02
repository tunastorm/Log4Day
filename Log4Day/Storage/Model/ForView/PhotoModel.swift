//
//  PhotoModel.swift
//  Log4Day
//
//  Created by 유철원 on 10/2/24.
//

import Foundation
import RealmSwift

struct PhotoModel {
    var id: ObjectId
    var name: String
    var place: PlaceModel?
    var createdAt: Date
    var owner: LogModel
    
    init(photo: Photo) {
        self.id = photo.id
        self.name = photo.name
        self.place = photo.place.map { PlaceModel(place: $0) }
        self.createdAt = photo.createdAt
        self.owner = photo.owner.map{ LogModel(log: $0) }[0]
    }
}
