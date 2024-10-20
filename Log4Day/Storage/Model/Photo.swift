//
//  Photo.swift
//  Log4Day
//
//  Created by 유철원 on 9/22/24.
//

import Foundation
import RealmSwift

final class Photo: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var place: Place?
    @Persisted var createdAt: Date
    @Persisted var owner = LinkingObjects(fromType: Log.self, property: Log.Column.fourCut.name)
    
    convenience init(name: String, place: Place) {
        self.init()
        self.name = name
        self.place = place
        self.createdAt = Date()
    }
    
    enum Column: String, CaseIterable, ManagedObject {
        case name
        case place
        case url
        case createdAt
        case owner
        
        var allCase: [Self] {
            return Self.allCases
        }
        
        var name: String {
            return self.rawValue
        }
        
        var krName: String {
            return switch self {
            case .name: "이름"
            case .place: "장소"
            case .url: "경로"
            case .createdAt: "작성일"
            case .owner: "참조된 로그"
            }
        }
    }
    
}
