//
//  RealmConfiguration.swift
//  Log4Day
//
//  Created by 유철원 on 9/22/24.
//

import Foundation
import RealmSwift

class RealmConfiguration {
    static let realmURL =
    FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "groupdefault.realm")
    
    static func getConfig() -> Realm.Configuration{
        let config = Realm.Configuration(fileURL: RealmConfiguration.realmURL,schemaVersion: 40) { migration, oldVersion in
            if oldVersion < 1 {
//                migration.enumerateObjects(ofType: Category.className()) { oldObject, newObject in
//                }
            }
            
            if oldVersion < 2 {
                
            }
            
        }
        return config
    }
}
