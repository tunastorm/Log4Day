//
//  SearchPlaceViewModel.swift
//  Log4Day
//
//  Created by 유철원 on 9/25/24.
//

import Foundation
import Combine


final class SearchPlaceViewModel: ObservableObject {
    
    private var cancelables = Set<AnyCancellable>()
    
    private let repository = Repository.shared
    
    var input = Input()
    
    @Published var output = Output()
    
    struct Action {
        
    }
    
    struct Input {
        
    }
    
    struct Output {
        var searchKeyword: String = ""
    }
    
    init() {
        
    }
    
}
