//
//  LogMapViewModel.swift
//  Log4Day
//
//  Created by 유철원 on 9/24/24.
//

import Foundation
import Combine
import SwiftUI
import PhotosUI
import NMapsMap
import BottomSheet
import RealmSwift

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
        @ObservedResults(Log.self) var logList
    }
    
}
