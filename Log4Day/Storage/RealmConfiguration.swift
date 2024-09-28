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
        
        let config = Realm.Configuration(schemaVersion: 5) { migration, oldSchemaVersion in

            if oldSchemaVersion < 1 {
                
            }
            
            if oldSchemaVersion < 2 {
                
            }
            
            if oldSchemaVersion < 3 {
                
            }
            
            if oldSchemaVersion < 4 {
                
            }
            
            if oldSchemaVersion < 5 {
                
            }
            
        }
        
        return config
    }
}
