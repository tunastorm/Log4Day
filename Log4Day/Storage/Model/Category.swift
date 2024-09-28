//
//  Category.swift
//  Log4Day
//
//  Created by 유철원 on 9/21/24.
//

import Foundation
import RealmSwift

final class Category: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var content: List<Log>
    @Persisted var createdAt: Date
    
    convenience init(title: String) {
        self.init()
        self.title = title
        self.content = List<Log>()
        self.createdAt = Date()
    }
    
    enum Column: String, CaseIterable, ManagedObject {
        case title
        case content
        case createdAt
        
        var allCase: [Self] {
            return Self.allCases
        }
        
        var name: String {
            return self.rawValue
        }
        
        var krName: String {
            return switch self {
            case .title: "이름"
            case .content: "내용"
            case .createdAt: "작성일"
            }
        }
    }
    
}
