//
//  NewLogViewModel.swift
//  Log4Day
//
//  Created by 유철원 on 9/24/24.
//

import Foundation
import Combine
import SwiftUI

final class NewLogViewModel: ObservableObject {
    
    private let repository = Repository.shared
    private var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    struct Action {
        
    }
    
    struct Input {
        var titleTextFieldReturn = PassthroughSubject<Void, Never>()
        var title = ""
    }
    
    struct Output {
        
    }
    
    init() {
        
    }
    
    func action(_ action: Action) {
        
    }
    
}
