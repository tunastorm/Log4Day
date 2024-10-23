//
//  RealmConfiguration.swift
//  Log4Day
//
//  Created by 유철원 on 9/22/24.
//

import Foundation
import RealmSwift

class RealmConfiguration {
    
    static func getConfig() -> Realm.Configuration{
        
        let config = Realm.Configuration(schemaVersion: 0) { migration, oldSchemaVersion in

        
        }
        
        return config
    }
    
}
