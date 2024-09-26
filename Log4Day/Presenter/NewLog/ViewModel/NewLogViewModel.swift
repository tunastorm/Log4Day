//
//  NewLogViewModel.swift
//  Log4Day
//
//  Created by 유철원 on 9/24/24.
//

import Foundation
import Combine
import SwiftUI
import PhotosUI
import NMapsMap

final class NewLogViewModel: ObservableObject {
    
    private let repository = Repository.shared
    
    private var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    enum Action {
        case placePicked(place: SearchedPlace)
        case photoPicked
        case deleteButtonTapped(lastOnly: Bool)
    }
    
    struct Input {
        var titleTextFieldReturn = PassthroughSubject<Void, Never>()
        var placePicked = PassthroughSubject<SearchedPlace, Never>()
        var photoPicked = PassthroughSubject<Void, Never>()
        var deleteButtonTapped = PassthroughSubject<Bool, Never>()
        var title = ""
        var selectedPlace: [Int] = []
        var pickedPhotos: [UIImage] = []
    }
    
    struct Output {
        var cameraPointer = 0
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
        
        input.photoPicked
            .sink { [weak self] _ in
                self?.addPhotos()
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
        case .photoPicked:
            input.photoPicked.send(())
        case .deleteButtonTapped(let lastOnly):
            input.deleteButtonTapped.send(lastOnly)
        }
    }
    
    private func addDotToCoordinate(mapX: String, mapY: String) -> (Double, Double)? {
        guard let X = Double(mapX), let Y = Double(mapY) else {
            return nil
        }
        return (Y / 1e7, X / 1e7)
    }
    
    private func addPickedPlace(_ searched: SearchedPlace) {
        guard let coordinate =  addDotToCoordinate(mapX: searched.mapX, mapY: searched.mapY) else {
            return
        }
        
        let replacedTitle = searched.title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
        
        let place = Place(isVisited: false, hashtag: "", name: replacedTitle, city: "", address: searched.address, longitude: coordinate.1, latitude: coordinate.0, createdAt: Date())
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
        print("선택된 장소 목록:", input.selectedPlace)
    }
    
    private func addPhotos() {
        
        input.pickedPhotos.forEach { image in
            
        }
        
    }
    
}
