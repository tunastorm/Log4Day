//
//  LogDetailViewModel.swift
//  Log4Day
//
//  Created by 유철원 on 9/25/24.
//

import Foundation
import Combine

final class LogDetailViewModel: ObservableObject {
    
    private var cancelables = Set<AnyCancellable>()
    
    var input = Input()
    
    @Published var output = Output()
    
    enum Action {
        
    }
    
    struct Input {
        var selectedPlace = 0
    }
    
    struct Output {
        var tagList: [String] = []
        var placeList: [Place] = []
        var photoList: [Photo] = []
    }
    
}
