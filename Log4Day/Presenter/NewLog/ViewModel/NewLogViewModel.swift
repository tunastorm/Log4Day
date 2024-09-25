//
//  NewLogViewModel.swift
//  Log4Day
//
//  Created by 유철원 on 9/24/24.
//

import Foundation
import Combine
import SwiftUI
import NMapsMap

final class NewLogViewModel: ObservableObject {
    
    private let repository = Repository.shared
    private var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    enum Action {
        case placePicked(place: SearchedPlace)
        case deleteButtonTapped(lastOnly: Bool)
    }
    
    struct Input {
        var titleTextFieldReturn = PassthroughSubject<Void, Never>()
        var placePicked = PassthroughSubject<SearchedPlace, Never>()
        var deleteButtonTapped = PassthroughSubject<Bool, Never>()
        var title = ""
        var selectedPlace: [Int] = []
    }
    
    struct Output {
        var tagList: [String] = []
        var placeList: [Place] = []
        var photoList: [Photo] = []
    }
    
    init() {
        input.placePicked
            .sink { [weak self] searchedPlace in
                self?.addPickedPlace(searchedPlace)
            }
            .store(in: &cancellables)
        
        input.deleteButtonTapped
            .sink { [weak self] lastOnly in
                self?.deletePickedPlace(lastOnly)
            }
            .store(in: &cancellables)
    }
    
    func action(_ action: Action) {
        switch action {
        case .placePicked(let place):
            input.placePicked.send(place)
        case .deleteButtonTapped(let lastOnly):
            input.deleteButtonTapped.send(lastOnly)
        }
    }
    
    private func addPickedPlace(_ searched: SearchedPlace) {
        guard let mapX = Double(searched.mapX), let mapY = Double(searched.mapY) else {
            return
        }
        let tm128 = NMGTm128(x: mapX, y: mapY)
        let coordinate = tm128.toLatLng()
        
        let replacedTitle = searched.title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
        
        let place = Place(isVisited: false, hashtag: "", name: replacedTitle, city: "", address: searched.address, longitude: coordinate.lng, latitude: coordinate.lat, createdAt: Date())
        output.placeList.append(place)
    }
    
    private func deletePickedPlace(_ lastOnly: Bool) {
        if lastOnly { // 검색 창에서 선택된 버튼 해제 시 실행
            let last = output.placeList.count-1
            output.placeList.remove(at: last)
        } else { // 새 로그 작성 화면에서 선택된 셀 해제 시 실행
            guard input.selectedPlace.count > 0 else {
                print(#function, "선택된 장소없음")
                return
            }
            output.placeList.remove(atOffsets: IndexSet(input.selectedPlace))
            input.selectedPlace.removeAll()
        }
//        input.selectedPlace.forEach { output.placeList.remove(at: $0) }
      
        print("선택된 장소 목록:", input.selectedPlace)
    }
    
    private func pinToMap() {
        
    }
    
}
