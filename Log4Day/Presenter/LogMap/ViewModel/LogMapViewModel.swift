//
//  LogMapViewModel.swift
//  Log4Day
//
//  Created by 유철원 on 9/24/24.
//

import Foundation
import Combine

final class LogMapViewModel: ObservableObject {
    
    private var canclelables = Set<AnyCancellable>()
    
    var input = Input()
    
    @Published var output = Output()
    
    enum Action {
        case selectPlace
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
