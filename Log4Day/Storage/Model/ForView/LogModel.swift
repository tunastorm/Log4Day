//
//  Log.swift
//  Log4Day
//
//  Created by 유철원 on 10/2/24.
//

import Foundation
import RealmSwift

struct LogModel: Identifiable {
    var id: ObjectId
    var title: String
    var startDate: Date
    var endDate: Date
    var places: [PlaceModel]
    var fourCut: [PhotoModel]
    var createdAt: Date
    var owner: CategoryModel
    
    init(log: Log) {
        self.id = log.id
        self.title = log.title
        self.startDate = log.startDate
        self.endDate = log.endDate
        self.places = log.places.map{ PlaceModel(place: $0) }
        self.fourCut = log.fourCut.map { PhotoModel(photo: $0)}
        self.createdAt = log.createdAt
        self.owner = log.owner.map{ CategoryModel(category: $0)}[0]
    }
}
