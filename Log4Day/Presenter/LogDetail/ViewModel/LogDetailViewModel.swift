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
        case placePicked(place: SearchedPlace)
        case canclePicked
        case photoPicked
        case deleteButtonTapped(lastOnly: Bool)
        case createLog
        case updateLog(id: ObjectId)
        case deleteLog(id: ObjectId)
        case setLog(id: ObjectId)
    }
    
    struct Input {
        var titleTextFieldReturn = PassthroughSubject<Void, Never>()
        var placePicked = PassthroughSubject<SearchedPlace, Never>()
        var canclePicked = PassthroughSubject<Void, Never>()
        var photoPicked = PassthroughSubject<Void, Never>()
        var deleteButtonTapped = PassthroughSubject<Bool, Never>()
        var createLog = PassthroughSubject<Void, Never>()
        var updateLog = PassthroughSubject<ObjectId, Never>()
        var deleteLog = PassthroughSubject<ObjectId, Never>()
        var setLog = PassthroughSubject<ObjectId, Never>()
        var title = ""
        var pickedImages: [UIImage] = []
        var pickedPlaces: [Int] = []
    }
    
    struct Output {
        var category = ""
        var date = Date()
        var showPlaceListSheet: BottomSheetPosition = .hidden
        var cameraPointer = 0
        var tagList: [String] = []
        var placeList: [Place] = []
        var imageDict: [Int:[UIImage]] = [:]
        var coordinateList: [NMGLatLng] = []
        var createResult: RepositoryResult = RepositoryStatus.idle
        var updateResult: RepositoryResult = RepositoryStatus.idle
    }
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(cancelPickedPlaces),
                                               name: NSNotification.Name("DismissedWithSwipe"),
                                               object: nil)
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
        input.updateLog
            .sink { [weak self] id in
                self?.updateLog(id: id)
            }
            .store(in: &cancellables)
        input.deleteLog
            .sink { [weak self] id in
                self?.deleteLog(id)
            }
            .store(in: &cancellables)
        input.setLog
            .sink { [weak self] id in
                self?.setLog(id: id)
            }
            .store(in: &cancellables)
        input.canclePicked
            .sink { [weak self] _ in
                self?.cancelPickedPlaces()
            }
            .store(in: &cancellables)
    }
    
    func action(_ action: Action) {
        switch action {
        case .placePicked(let place):
            input.placePicked.send(place)
        case .canclePicked:
            input.canclePicked.send(())
        case .photoPicked:
            input.photoPicked.send(())
        case .deleteButtonTapped(let lastOnly):
            input.deleteButtonTapped.send(lastOnly)
        case .createLog:
            input.createLog.send(())
        case .updateLog(let id):
            input.updateLog.send(id)
        case.deleteLog(let id):
            input.deleteLog.send(id)
        case .setLog(let id):
            input.setLog.send(id)
        }
    }
    
    private func showPlaceListSheet() {
        output.showPlaceListSheet = output.showPlaceListSheet == .hidden ? .dynamic : .hidden
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
    }
    
    private func deletePickedPlace(_ lastOnly: Bool) {
        
        if lastOnly { // 검색 창에서 선택된 버튼 해제 시 실행
            output.coordinateList.remove(at: output.coordinateList.count-1)
            output.placeList.remove(at: output.placeList.count-1)
        } else { // 새 로그 작성 화면에서 선택된 셀 해제 시 실행
            output.imageDict.removeValue(forKey: output.cameraPointer)
            output.coordinateList.remove(at: output.cameraPointer)
            output.placeList.remove(at: output.cameraPointer)
            output.cameraPointer = output.placeList.count == 0 ? 0 : output.placeList.count-2
            print("삭제후 카메라 위치:", output.cameraPointer)
        }
        
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
        output.imageDict[output.cameraPointer] = resizedList
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
            let image = self?.photoManager.loadImageToDocument(filename: photo.name) ?? UIImage(systemName: "photo")!
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
    
    private func updateLog(id: ObjectId) {
        guard let log = repository.fetchItem(object: Log.self, primaryKey: id) else {
            return
        }
        repository.queryProperty { [weak self] in
            self?.updateLogCategory(log)
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

    private func updateLogCategory(_ log: Log) {
        if let owner = log.owner.first {
            if owner.title == output.category {
                let filtered = owner.content.filter({ $0.id == log.id })
                if filtered.count > 0, let old = filtered.first {
                    old.title = input.title
                }
            } else {
                var index: Int?
                owner.content.enumerated().forEach { idx, old in
                    if old.id == log.id {
                        index = idx
                    }
                }
                if let index {
                    owner.content.remove(at: index)
                    if output.category != "" {
                        addLogToCategory(log)
                    }
                }
                updateProperties(log)
            }
        } else if output.category != "" {
            addLogToCategory(log)
        } else {
            updateProperties(log)
        }
    }
   
    private func updateProperties(_ log: Log) {
        let old = repository.fetchItem(object: Log.self, primaryKey: log.id)
        old?.title = input.title
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
        output.showPlaceListSheet = .hidden
        output.cameraPointer = 0
        output.tagList.removeAll()
        output.placeList.removeAll()
        output.imageDict.removeAll()
        output.coordinateList.removeAll()
        output.createResult = RepositoryStatus.idle
        output.updateResult = RepositoryStatus.idle
    }
    
    
}
