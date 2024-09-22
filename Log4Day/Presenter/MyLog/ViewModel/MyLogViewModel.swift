//
//  MyLogViewModel.swift
//  Log4Day
//
//  Created by 유철원 on 9/22/24.
//

import Foundation
import Combine
import RealmSwift
import SwiftUI

final class MyLogViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    private let repository = Repository.shared
    
    var input = Input()
    
    @Published var output = Output()
    
    enum Action {
    
    }
    
    struct Input {
      
    }
    
    struct Output {
        var screenWidth = UIScreen.main.bounds.width
    }
    
    init() {
      
    }
    
    func action(_ action: Action) {
//        switch action {
//      
//        }
    }
   
    
}

