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
    
    private let photoManager = PhotoManager.shared
    
    private var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    enum Action {
        case placePicked(place: SearchedPlace)
        case photoPicked
        case deleteButtonTapped(lastOnly: Bool)
        case createLog
    }
    
    struct Input {
        var titleTextFieldReturn = PassthroughSubject<Void, Never>()
        var placePicked = PassthroughSubject<SearchedPlace, Never>()
        var photoPicked = PassthroughSubject<Void, Never>()
        var deleteButtonTapped = PassthroughSubject<Bool, Never>()
        var createLog = PassthroughSubject<Void, Never>()
        var title = ""
        var deleteMember: [Int] = []
        var pickedImages: [UIImage] = []
    }
    
    struct Output {
        var category = ""
        var date = Date()
        var showAddSheet = false
        var isDeleteMode: Bool = false
        var cameraPointer = 0
        var tagList: [String] = []
        var placeList: [Place] = []
        var imageDict: [Int:[UIImage]] = [:]
        var photoDict: [Int:[Photo]]?
        var coordinateList: [NMGLatLng] = []
        var createResult: RepositoryResult = RepositoryStatus.idle
    }
    
    init() {
        input.placePicked
            .sink { [weak self] searchedPlace in
                self?.addPickedPlace(searchedPlace)
            }
            .store(in: &cancellables)
        
        input.photoPicked
            .sink { [weak self] _ in
                self?.addImages()
            }
            .store(in: &cancellables)
        
        input.deleteButtonTapped
            .sink { [weak self] lastOnly in
                self?.deletePickedPlace(lastOnly)
            }
            .store(in: &cancellables)
        input.createLog
            .sink { [weak self] _ in
                self?.createLog()
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
        case .createLog:
            input.createLog.send(())
        }
    }
    
    private func divideCoordinate(mapX: String, mapY: String) -> (Double, Double)? {
        guard let X = Double(mapX), let Y = Double(mapY) else {
            return nil
        }
        return (Y / 1e7, X / 1e7)
    }
    
    private func addPickedPlace(_ searched: SearchedPlace) {
        
        guard let coordinate = divideCoordinate(mapX: searched.mapX, mapY: searched.mapY),
              !output.placeList.map { ($0.longitude, $0.latitude) }.contains(where: { $0 == coordinate }) else {
            return
        }
        
        let replacedTitle = searched.title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
        
        let place = Place(isVisited: false, hashtag: "", name: replacedTitle, city: "", address: searched.roadAddress, longitude: coordinate.1, latitude: coordinate.0)
        
        let nmgLatLng = NMGLatLng(lat: coordinate.0, lng: coordinate.1)
        
        output.placeList.append(place)
        output.coordinateList.append(nmgLatLng)
        output.cameraPointer = output.placeList.count-1
    }
    
    private func deletePickedPlace(_ lastOnly: Bool) {
        
        if lastOnly { // 검색 창에서 선택된 버튼 해제 시 실행
            output.coordinateList.remove(at: output.coordinateList.count-1)
            output.placeList.remove(at: output.placeList.count-1)
        } else { // 새 로그 작성 화면에서 선택된 셀 해제 시 실행
            guard input.deleteMember.count > 0 else {
                print(#function, "선택된 장소없음")
                return
            }
            let places = IndexSet(input.deleteMember)
            output.coordinateList.remove(atOffsets: places)
            output.placeList.remove(atOffsets: places)
            output.cameraPointer = output.placeList.count == 0 ? 0 : output.placeList.count-2
            input.deleteMember.forEach{ output.imageDict.removeValue(forKey: $0) }
            input.deleteMember.removeAll()
        }
        print("선택된 장소 목록:", input.deleteMember)
    }
    
    private func addImages() {
        
        let count = output.imageDict.values.flatMap{ $0 }.count
        
        if count >= 4 {
            return
        }
        
        if !output.imageDict.keys.contains(output.cameraPointer) {
            output.imageDict[output.cameraPointer] = []
        }
        output.imageDict[output.cameraPointer] = input.pickedImages
        input.pickedImages.removeAll()
        
    }
    
    private func createLog() {
        
        let log = Log(title: input.title,
                      startDate: output.date,
                      endDate: output.date)
        
        output.placeList.enumerated().forEach { index, place in
            
            if output.imageDict.keys.contains(index) {
                output.imageDict[index]?.enumerated().forEach { index, image in
                    let filename = "\(place.id)_\(index)"
                    photoManager.saveImageToDocument(image: image, filename: filename)
                    let photo = Photo(name: filename, place: place)
                    log.fourCut.append(photo)
                }
            }
            
            log.places.append(place)
        }
        
        if output.category != "" {
            repository.queryProperty { [weak self] in
                let category = self?.repository
                                    .fetchAllFiltered(obejct:Category.self,
                                                      sortKey: Category.Column.createdAt,
                                                      query: { $0.title.equals(self?.output.category ?? "") })?.first
                category?.content.append(log)
            } completionHandler: { [weak self] result in
                switch result {
                case .success(let rawStatus):
                    let status = rawStatus as RepositoryStatus
                    self?.output.createResult = status
                case .failure(let rawError):
                    let error = rawError as RepositoryError
                    self?.output.createResult = error
                }
            }
        } else {
            repository.createItem(log) { [weak self] result in
                switch result {
                case .success(let rawStatus):
                    let status = rawStatus as RepositoryStatus
                    self?.output.createResult = status
                case .failure(let rawError):
                    let error = rawError as RepositoryError
                    self?.output.createResult = error
                }
            }
        }
        resetData()
    }
    
    private func repositorResultHandler(result: RepositoryResult) {
       
    }
    
    private func resetData() {
        input.title = ""
        input.deleteMember.removeAll()
        input.pickedImages.removeAll()
        output.category = ""
        output.date = Date()
        output.showAddSheet = false
        output.isDeleteMode = false
        output.cameraPointer = 0
        output.tagList.removeAll()
        output.placeList.removeAll()
        output.imageDict.removeAll()
        output.photoDict?.removeAll()
        output.coordinateList.removeAll()
        output.createResult = RepositoryStatus.idle
    }

}
