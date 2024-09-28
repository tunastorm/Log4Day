//
//  LogDetailViewModel.swift
//  Log4Day
//
//  Created by 유철원 on 9/25/24.
//

import Foundation
import Combine
import NMapsMap

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
        var isDeleteMode = false
        var cameraPointer = 0
        var tagList: [String] = []
        var placeList: [Place] = []
        var photoDict: [Int:[Photo]]?
        var imageDict: [Int:[UIImage]] = [:]
        var coordinateList: [NMGLatLng] = []
    }
    
}
