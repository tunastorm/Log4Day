//
//  ColumnManager.swift
//  Log4Day
//
//  Created by 유철원 on 9/21/24.
//

import Foundation


enum QueryCondition: String {
    case contains
    case equals
    
    var value: String {
        return switch self {
        case .contains:
            "CONTAINS[c]"
        case .equals:
            "=="
        }
    }
}

protocol ManagedObject {
    
    var name: String { get }
    
    var krName: String { get }
    
    var inputErrorMessage: String { get }
    
    var updatePropertySuccessMessage: String { get }
    
    var updatePropertyErrorMessage: String { get }
    
    var allCase: [Self] { get }
    
    func query(search: String, condition: QueryCondition) -> NSPredicate
    
    func queryMultiProperty(search: String, propertys: [Self], condition: QueryCondition) -> NSCompoundPredicate
    
}


extension ManagedObject {
    
    var inputErrorMessage: String {
        return "\(self.krName) 값이 없거나 유효하지 않습니다."
    }
    
    var updatePropertySuccessMessage: String {
        return "\(self.krName) 의 수정이 완료되었습니다."
    }
    
    var updatePropertyErrorMessage: String {
        return "\(self.krName) 의 수정에 실패하였습니다."
    }
    
    // can't use for owner property
    func query(search: String, condition: QueryCondition) -> NSPredicate {
        let predicate = "\(self.name) \(condition.value) '\(search)'"
//        print(#function, "predicate:", predicate)
        return NSPredicate(format:predicate)
    }
    
    func queryMultiProperty(search: String, propertys: [Self], condition: QueryCondition) -> NSCompoundPredicate {
        var filterArray: [NSPredicate] = []
        for item in propertys {
            let predicate = "\(item.name) \(condition.value) '\(search)'"
            filterArray.append(NSPredicate(format:predicate))
        }
        return NSCompoundPredicate(type: .or, subpredicates: filterArray)
    }
    
}
