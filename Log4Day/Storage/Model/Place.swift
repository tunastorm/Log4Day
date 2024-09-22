//
//  Place.swift
//  Log4Day
//
//  Created by 유철원 on 9/22/24.
//

import Foundation
import RealmSwift

final class Place: Object, ObjectKeyIdentifiable/*, Codable*/ {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var isVisited: Bool
    @Persisted var hashtag: String
    @Persisted var name: String
    @Persisted var city: String
    @Persisted var address: String
    @Persisted var longitude: Double
    @Persisted var latitude: Double
    @Persisted var createdAt: Date
    @Persisted var owner = LinkingObjects(fromType: Log.self, property: Log.Column.places.name)
    
    convenience init(isVisited: Bool, hashtag: String, name: String, city: String, address: String, longitude: Double, latitude: Double, createdAt: Date) {
        self.init()
        self.isVisited = isVisited
        self.hashtag = hashtag
        self.name = name
        self.city = city
        self.address = address
        self.longitude = longitude
        self.latitude = latitude
        self.createdAt = createdAt
    }
    
    enum Column: String, CaseIterable, ManagedObject {
        case isVisited
        case hashtag
        case name
        case city
        case address
        case longitude
        case latitude
        case createdAt
    
        var allCase: [Self] {
            return Self.allCases
        }
        
        var name: String {
            return self.rawValue
        }
        
        var krName: String {
            return switch self {
            case .isVisited: "방문여부"
            case .hashtag: "해시태그"
            case .name: "이름"
            case .city: "도시"
            case .address: "주소"
            case .longitude: "경도"
            case .latitude: "위도"
            case .createdAt: "작성일"
            }
        }
    }
    
    // 네트워크 결과를 곧바로 RealmObject로 디코딩 할 수 있음
//
//    enum CodingKeys: String, CodingKey {
//        
//            case contentId = "contentid"
//            case image = "firstimage"
//            
//        }
        
//    required convenience init(from decoder: Decoder) throws {
//        self.init()
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//      
//        contentId = Int(try container.decode(String.self, forKey: .contentId)) ?? 0
//        image = try container.decode(String.self, forKey: .image)
//        
//    }
    
}
