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
import BottomSheet
import RealmSwift

final class LogDetailViewModel: ObservableObject {
    
    private let repository = Repository.shared
    
    private let photoManager = PhotoManager.shared
    
    private var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    enum Action {
        case moveCameraPointer(pointer: Int)
        case placePicked(place: SearchedPlace)
        case cancelPickedPlaces
        case photoPicked
        case deleteButtonTapped(lastOnly: Bool)
        case placeEditButtonTapped
        case changeLoadingState
        case editPickedImages
        case validate
        case createLog
        case updateLog(id: ObjectId)
        case deleteLog(id: ObjectId)
        case setLog(id: ObjectId)
    }
    
    struct Input {
        let moveCameraPointer = PassthroughSubject<Int, Never>()
        let titleTextFieldReturn = PassthroughSubject<Void, Never>()
        let placePicked = PassthroughSubject<SearchedPlace, Never>()
        let cancelPickedPlaces = PassthroughSubject<Void, Never>()
        let photoPicked = PassthroughSubject<Void, Never>()
        let deleteButtonTapped = PassthroughSubject<Bool, Never>()
        let placeEditButtonTapped = PassthroughSubject<Void, Never>()
        let changeLoadingState = PassthroughSubject<Void, Never>()
        let cancelPickedImages = PassthroughSubject<Void, Never>()
        let validate = PassthroughSubject<Void, Never>()
        let createLog = PassthroughSubject<Void, Never>()
        let updateLog = PassthroughSubject<ObjectId, Never>()
        let deleteLog = PassthroughSubject<ObjectId, Never>()
        let setLog = PassthroughSubject<ObjectId, Never>()
        var title = ""
        var pickedImages: [UIImage] = []
        var pickedPlaces: [Int] = []
        var editImages: [Int] = []
    }
    
    struct Output {
        var category = ""
        var date = Date()
        var showPlaceEditSheet: BottomSheetPosition = .hidden
        var cameraPointer = 0
        var tagList: [String] = []
        var placeList: [Place] = []
        var imageDict: [Int:[UIImage]] = [:]
        var coordinateList: [NMGLatLng] = []
        var editImages: [Int] = []
        var inValid = true
        var createResult: RepositoryResult = RepositoryStatus.idle
        var updateResult: RepositoryResult = RepositoryStatus.idle
        var loadingState: Bool = false
    }
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(cancelPickedPlaces),
                                               name: NSNotification.Name("DismissedWithSwipe"),
                                               object: nil)
        input.moveCameraPointer
            .withUnretained(self)
            .sink { owner, output in
                owner.moveCameraPointer(pointer: output)
            }
            .store(in: &cancellables)
        
        input.placePicked
            .withUnretained(self)
            .sink { owner, output in
                owner.addPickedPlace(output)
            }
            .store(in: &cancellables)
        
        input.photoPicked
            .withUnretained(self)
            .sink { owner, _ in
                owner.addImages()
            }
            .store(in: &cancellables)
        
        input.deleteButtonTapped
            .withUnretained(self)
            .sink { owner, output in
                owner.deletePickedPlace(output)
            }
            .store(in: &cancellables)
        
        input.placeEditButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.togglePlaceEditSheet()
            }
            .store(in: &cancellables)
        
        input.validate
            .withUnretained(self)
            .sink { owner, _ in
                owner.validate()
            }
            .store(in: &cancellables)
        
        input.createLog
            .withUnretained(self)
            .sink { owner, _ in
                owner.createLog()
            }
            .store(in: &cancellables)
        
        input.updateLog
            .withUnretained(self)
            .sink { owner, output in
                owner.updateLog(id: output)
            }
            .store(in: &cancellables)
        
        input.deleteLog
            .withUnretained(self)
            .sink { owner, output in
                owner.deleteLog(output)
            }
            .store(in: &cancellables)
        
        input.setLog
            .withUnretained(self)
            .sink { owner, output in
                owner.setLog(id: output)
            }
            .store(in: &cancellables)
        
        input.changeLoadingState
            .withUnretained(self)
            .sink { owner, _ in
                owner.changeLoadingState()
            }
            .store(in: &cancellables)
        
        input.cancelPickedPlaces
            .withUnretained(self)
            .sink { owner, _ in
                owner.cancelPickedPlaces()
            }
            .store(in: &cancellables)
        input.cancelPickedImages
            .withUnretained(self)
            .sink { owner, _ in
                owner.cancelPickedImages()
            }
            .store(in: &cancellables)
    }
    
    func action(_ action: Action) {
        switch action {
        case .moveCameraPointer(let pointer):
            input.moveCameraPointer.send(pointer)
        case .placePicked(let place):
            input.placePicked.send(place)
        case .cancelPickedPlaces:
            input.cancelPickedPlaces.send(())
        case .photoPicked:
            input.photoPicked.send(())
        case .deleteButtonTapped(let lastOnly):
            input.deleteButtonTapped.send(lastOnly)
        case .placeEditButtonTapped:
            input.placeEditButtonTapped.send(())
        case .validate:
            input.validate.send(())
        case .createLog:
            input.createLog.send(())
        case .updateLog(let id):
            input.updateLog.send(id)
        case.deleteLog(let id):
            input.deleteLog.send(id)
        case .setLog(let id):
            input.setLog.send(id)
        case .changeLoadingState:
            input.changeLoadingState.send(())
        case .editPickedImages:
            input.cancelPickedImages.send(())
        }
    }
    
    private func moveCameraPointer(pointer: Int) {
        output.cameraPointer = pointer
    }
    
    private func togglePlaceEditSheet() {
        output.showPlaceEditSheet = output.showPlaceEditSheet == .hidden ? .dynamic : .hidden
    }
    
    private func divideCoordinate(mapX: String, mapY: String) -> (Double, Double)? {
        
        guard let X = Double(mapX), let Y = Double(mapY) else {
            return nil
        }
        return (Y / 1e7, X / 1e7)
        
    }
    
    private func addPickedPlace(_ searched: SearchedPlace) {
        
        guard let coordinate = divideCoordinate(mapX: searched.mapX, mapY: searched.mapY),
              !output.placeList.map({ ($0.longitude, $0.latitude) }).contains(where: { $0 == coordinate }) else {
            return
        }
        
        let replacedTitle = searched.title.replacingOccurrences(of: "<b>", with: "")
                                          .replacingOccurrences(of: "</b>", with: "")
                                          .replacingOccurrences(of: "&amp;", with: "")
        
        let place = Place(isVisited: false, hashtag: "", name: replacedTitle, city: "", address: searched.roadAddress, longitude: coordinate.1, latitude: coordinate.0)
        
        let nmgLatLng = NMGLatLng(lat: coordinate.0, lng: coordinate.1)
        
        output.placeList.append(place)
        output.coordinateList.append(nmgLatLng)
        output.cameraPointer = output.placeList.count-1
        input.pickedPlaces.append(output.cameraPointer)
        validate()
    }
    
    private func deletePickedPlace(_ lastOnly: Bool) {
        
        if lastOnly { // 검색 창에서 선택된 버튼 해제 시 실행
            output.coordinateList.remove(at: output.coordinateList.count-1)
            output.placeList.remove(at: output.placeList.count-1)
        } else { // 새 로그 작성 화면에서 선택된 셀 해제 시 실행
            output.imageDict.removeValue(forKey: output.cameraPointer)
            output.coordinateList.remove(at: output.cameraPointer)
            output.placeList.remove(at: output.cameraPointer)
        }
        output.cameraPointer = output.placeList.count <= 1 ? 0 : output.placeList.count-2
        validate()
    }
    
    @objc private func cancelPickedPlaces() {
        guard input.pickedPlaces.count > 0 else {
            return
        }
        let removeSet = IndexSet(input.pickedPlaces)
        input.pickedPlaces.forEach { output.imageDict.removeValue(forKey: $0) }
        output.coordinateList.remove(atOffsets: removeSet)
        output.placeList.remove(atOffsets: removeSet)
        output.cameraPointer = output.placeList.count == 0 ? 0 : output.placeList.count-2
        input.pickedPlaces.removeAll()
        validate()
    }
    
    private func validate() {
        output.inValid = input.title.isEmpty ||
                         input.title.count > 15 ||
                         input.title.replacingOccurrences(of: " ", with: "") == "" ||
                         output.placeList.isEmpty
    }
    
    private func changeLoadingState() {
        output.loadingState.toggle()
    }
    
    private func addImages() {
        
        let count = output.imageDict.values.flatMap{ $0 }.count
        
        if count >= 4 {
            return
        }
        
        if !output.imageDict.keys.contains(output.cameraPointer) {
            output.imageDict[output.cameraPointer] = []
        }
        var resizedList: [UIImage] = []
        input.pickedImages.forEach {
            if let image = $0.resize(to: CGSize(width: 0.2, height: 0.2)) {
                resizedList.append(image)
            }
        }
        output.imageDict[output.cameraPointer]?.append(contentsOf: resizedList)
        input.pickedImages.removeAll()
        togglePlaceEditSheet()
    }
    
    private func cancelPickedImages() {
        let cancelSet = IndexSet(input.editImages)
        output.imageDict[output.cameraPointer]?.remove(atOffsets: cancelSet)
        input.editImages.removeAll()
        togglePlaceEditSheet()
    }
    
    private func setLog(id: ObjectId) {
        guard let log = repository.fetchItem(object: Log.self, primaryKey: id) else {
            return
        }
        input.title = log.title
        output.category = log.owner.first?.title ?? ""
        output.date = log.startDate
        output.placeList = Array(log.places)
        output.coordinateList = log.places.map { NMGLatLng(lat: $0.latitude, lng: $0.longitude) }
        log.fourCut.forEach { [weak self] photo in
            guard let photoPlace = photo.place else {
                return
            }
            let image = self?.photoManager.loadImageFromDocument(filename: photo.name) ?? UIImage(systemName: "photo")!
            log.places.enumerated().forEach { index, place in
                if place.id == photoPlace.id {
                    if let keys = self?.output.imageDict.keys, !keys.contains(index) {
                        self?.output.imageDict[index] = []
                    }
                    self?.output.imageDict[index]?.append(image)
                }
            }
        }
    }
    
    private func setPlacesAndPhotosToLog(log: Log) -> Log {
        
        if log.fourCut.count > 0 {
            log.fourCut.removeAll()
        }
        
        if log.places.count > 0 {
            log.places.removeAll()
        }
        
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
        
        return log
    }
    
    private func createLog() {
        var log = Log(title: input.title,
                      startDate: output.date,
                      endDate: output.date)
        
        log = setPlacesAndPhotosToLog(log: log)
        
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
    
    private func updateLog(id: ObjectId) {
        guard var log = repository.fetchItem(object: Log.self, primaryKey: id) else {
            return
        }
        
        repository.queryProperty { [weak self] in
            log = setPlacesAndPhotosToLog(log: log)
            self?.updateLogAndCategory(log)
        } completionHandler: { result in
            switch result {
            case .success(let rawStatus):
                let status = rawStatus as RepositoryStatus
                output.updateResult = status
            case .failure(let rawError):
                let error = rawError as RepositoryError
                output.updateResult = error
            }
        }
    }

    private func updateLogAndCategory(_ log: Log) {
        if let owner = log.owner.first {
            // 카테고리 기존과 동일
            if owner.title == output.category {
                let filtered = owner.content.filter({ $0.id == log.id })
                // 프로퍼티 변경사항 수정
                if filtered.count > 0, let old = filtered.first {
                    old.title = input.title
                    old.fourCut = log.fourCut
                    old.places = log.places
                }
            // 카테고리 있음 -> 다른 카테고리 or 카테고리 없음으로 변경
            } else {
                var index: Int?
                owner.content.enumerated().forEach { idx, old in
                    if old.id == log.id {
                        index = idx
                    }
                }
                // 기존 카테고리에서 로그 삭제
                if let index {
                    owner.content.remove(at: index)
                    // 변경될 카테고리에 추가
                    if output.category != "" {
                        addLogToCategory(log)
                    }
                }
                // 프로퍼티 변경사항 수정
                updateProperties(log)
            }
        // 카테고리 없음 -> 특정 카테고리 부여
        } else if output.category != "" {
            addLogToCategory(log)
        // 프로퍼티만 변경됨
        } else {
            updateProperties(log)
        }
    }
   
    private func updateProperties(_ log: Log) {
        let old = repository.fetchItem(object: Log.self, primaryKey: log.id)
        old?.title = input.title
        // 삭제된 이미지 Document에서 제거하는 로직 필요
        let newIds = log.fourCut.map{ $0.id }
        old?.fourCut.forEach { photo in
            if !newIds.contains(photo.id) {
                PhotoManager.shared.removeImageFromDocument(filename: photo.name)
            }
        }
        old?.fourCut = log.fourCut
        old?.places = log.places
    }
    
    private func addLogToCategory(_ log: Log) {
        if let category = repository.fetchAllFiltered (
            obejct: Category.self,
            sortKey: Category.Column.title,
            query: { 
                [weak self] in $0.title.equals(self?.output.category ?? "")
            }
        )?.first {
            log.title = input.title
            category.content.append(log)
        }
    }
    
    private func deleteLog(_ id: ObjectId) {
        guard let log = repository.fetchItem(object: Log.self, primaryKey: id) else {
            return
        }
        repository.deleteLog(log) { result in
            switch result {
            case .success(let rawStatus):
                let status = rawStatus as RepositoryStatus
                output.updateResult = status
            case .failure(let rawError):
                let error = rawError as RepositoryError
                output.updateResult = error
            }
        }
    }

    private func resetData() {
        input.title = ""
        input.pickedImages.removeAll()
        output.category = ""
        output.date = Date()
        output.showPlaceEditSheet = .dynamicBottom
        output.cameraPointer = 0
        output.tagList.removeAll()
        output.placeList.removeAll()
        output.imageDict.removeAll()
        output.coordinateList.removeAll()
        output.createResult = RepositoryStatus.idle
        output.updateResult = RepositoryStatus.idle
    }
    
}
