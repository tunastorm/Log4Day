//
//  Log.swift
//  Log4Day
//
//  Created by 유철원 on 9/21/24.
//

import Foundation
import RealmSwift

final class Log: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    @Persisted var places: List<Place>
    @Persisted var fourCut: List<Photo>
    @Persisted var createdAt: Date
    @Persisted var owner = LinkingObjects(fromType: Category.self, property: Category.Column.content.name)
    
    convenience init(id: ObjectId, title: String, startDate: Date, endDate: Date, places: List<Place>, fourCut: List<Photo>, createdAt: Date) {
        self.init()
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.places = places
        self.fourCut = fourCut
        self.createdAt = createdAt
    }
    
    enum Column: String, CaseIterable, ManagedObject {
        
        case title
        case startDate
        case endDate
        case places
        case fourCut
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
            case .title: "이름"
            case .startDate: "시작일"
            case .endDate: "종료일"
            case .places: "장소목록"
            case .fourCut: "네컷사진"
            case .createdAt: "작성일"
            case .owner: "상위모델"
            }
        }
        
        
    }
    
    
}
