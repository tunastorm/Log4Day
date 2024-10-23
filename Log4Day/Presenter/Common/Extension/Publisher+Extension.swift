//
//  Publisher+Extension.swift
//  Log4Day
//
//  Created by 유철원 on 10/13/24.
//

import Foundation
import Combine

extension Publisher {
    
    func withUnretained<O: AnyObject>(_ owner: O) -> Publishers.CompactMap<Self, (O, Self.Output)> {
        compactMap { [weak owner] output in
            owner == nil ? nil : (owner!, output)
        }
    }
    
}

