//
//  CategoryModel.swift
//  Log4Day
//
//  Created by 유철원 on 10/2/24.
//

import Foundation
import RealmSwift

struct CategoryModel: Identifiable {
    var id: ObjectId
    var title: String
    var content: [LogModel]
    var createdAt: Date
    var objectId: ObjectId
    
    init(category: Category) {
        self.id = category.id
        self.title = category.title
        self.content = category.content.map{ LogModel(log: $0) }
        self.createdAt = category.createdAt
    }
}
