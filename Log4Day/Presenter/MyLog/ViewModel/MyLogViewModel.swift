//
//  MyLogViewModel.swift
//  Log4Day
//
//  Created by 유철원 on 9/24/24.
//

import SwiftUI
import Combine
import RealmSwift
import BottomSheet

final class MyLogViewModel: ObservableObject {
    
    private let repository = Repository.shared
    
    private let photoManager = PhotoManager()
    
    private var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    
    @Published var output = Output()
    
    enum Action {
        case changeCategory
        case fetchFirstLastDate
        case fetchCategorizedList
        case fetchLogDate(isInitial: Bool)
        case tapBarChanged(info: TapInfo)
        case placeCellTapped(indexInfo: (String,Int))
        case fourCutCellPressed(image: UIImage)
        case deleteLog(id: ObjectId)
    }
    
    struct Input {
        let changeCategory = PassthroughSubject<Void, Never>()
        let fetchFirstLastDate = PassthroughSubject<Void, Never>()
        let fetchCategorizedList = PassthroughSubject<Void, Never>()
        let fetchLogDate = PassthroughSubject<Bool, Never>()
        let tapBarChanged = PassthroughSubject<TapInfo, Never>()
        let placeCellTapped = PassthroughSubject<(String,Int), Never>()
        let fourCutCellPressed = PassthroughSubject<UIImage, Never>()
        var selectedCategory = ""
        var nowLogDate = DateFormatManager.shared.dateToFormattedString(date: Date(), format: .dotSeparatedyyyyMMddDay)
        var deleteLog = PassthroughSubject<ObjectId, Never>()
    }
    
    struct Output {
        var screenWidth = UIScreen.main.bounds.width
        var category = "전체"
        @ObservedResults(Log.self) var logList
        var timeline: [Log] = []
        var placeDict: [String:[Place]] = [:]
        var firstLastDate: (String, String) = (DateFormatManager.shared.dateToFormattedString(date: Date(), format: .dotSeparatedyyyyMMddDay), "")
        var logDate: String = ""
        var selectedPicker: TapInfo = .timeline
        var translation: CGSize = .zero
        var offsetX: CGFloat = -120
        var showSelectLogSheet: BottomSheetPosition = .hidden
        var ofLogList: [Log] = []
        var showSaveFourCutSheet: BottomSheetPosition = .hidden
        var fourCutImage: UIImage = UIImage()
    }
    
    init() {
        input.changeCategory
            .sink { [weak self] _ in
                self?.changeCategory()
            }
            .store(in: &cancellables)
        
        input.fetchFirstLastDate
            .sink { [weak self] _ in
                self?.fetchFirstLastDate()
            }
            .store(in: &cancellables)
        
        input.fetchCategorizedList
            .sink { [weak self] _ in
                self?.fetchCategorizedLogList()
            }
            .store(in: &cancellables)
        
        input.fetchLogDate
            .sink { [weak self] isInitial in
                self?.fetchFourCutLogDate(isInitial)
            }
            .store(in: &cancellables)
        
        input.tapBarChanged
            .sink { [weak self] info in
                self?.fetchTapBarData(tapInfo: info)
            }
            .store(in: &cancellables)
        
        input.placeCellTapped
            .sink { [weak self] indexInfo in
                self?.showSelectLogSheet(indexInfo)
            }.store(in: &cancellables)
        
        input.fourCutCellPressed
            .sink { [weak self] image in
                self?.showSaveImageSheet(image)
            }
            .store(in: &cancellables)
        
        input.deleteLog
            .sink { [weak self] id in
                self?.deletelog(id: id)
            }
            .store(in: &cancellables)
    }
    
    func action(_ action: Action) {
        switch action {
        case .changeCategory:
            input.changeCategory.send(())
        case .fetchFirstLastDate:
            input.fetchFirstLastDate.send(())
        case .fetchCategorizedList:
            input.fetchCategorizedList.send(())
        case .fetchLogDate(let isInitial):
            input.fetchLogDate.send(isInitial)
        case .tapBarChanged(let info):
            input.tapBarChanged.send(info)
        case .placeCellTapped(let indexInfo):
            input.placeCellTapped.send((indexInfo))
        case .fourCutCellPressed(let image):
            input.fourCutCellPressed.send(image)
        case .deleteLog(let id):
            input.deleteLog.send(id)
        }
    }
    
    private func changeCategory() {
        output.category = input.selectedCategory
        output.placeDict.removeAll()
    }
    
    private func fetchFirstLastDate() {
        let sorted = output.logList.sorted(by: {$0.startDate < $1.startDate})
        guard let first = sorted.first?.startDate, let last = sorted.last?.startDate else {
            return
        }
        let firstDate = DateFormatManager.shared.dateToFormattedString(date: first, format: .dotSeparatedyyyyMMddDay)
        let lastDate = DateFormatManager.shared.dateToFormattedString(date: last, format: .dotSeparatedyyyyMMddDay)
        output.firstLastDate = (firstDate, lastDate)
    }

    private func fetchCategorizedLogList() {
        if output.category == "전체" {
            output.$logList.where = { $0.createdAt <= Date() }
//            output.$elogList.sortDescriptor = .init(keyPath: Log.Column.startDate.name, ascending: false)
        } else {
            output.$logList.where = { [weak self] in
                return $0.owner.title == self?.output.category ?? ""
            }
        }
        output.$logList.sortDescriptor = .init(keyPath: Log.Column.startDate.name, ascending: false)
        output.$logList.update()
        fetchFirstLastDate()
    }

    private func fetchFourCutLogDate(_ isInitial: Bool) {
        if isInitial, let nowLog = output.logList.where({ $0.fourCut.count == 4 }).first {
            input.nowLogDate = DateFormatManager.shared.dateToFormattedString(date: nowLog.startDate, format: .dotSeparatedyyyyMMddDay)
        }
        output.logDate = input.nowLogDate
    }

    private func fetchTapBarData(tapInfo: TapInfo) {
        output.selectedPicker = tapInfo
        switch tapInfo {
        case .timeline:
            output.timeline = output.logList.sorted(by: { $0.startDate > $1.startDate })
        case .place:
            output.placeDict.removeAll()
            output.logList.forEach { log in
                guard let city = log.places.first?.city else {
                    return
                }
                if !output.placeDict.keys.contains(city) {
                    output.placeDict[city] = []
                }
                output.placeDict[city]?.append(contentsOf: log.places) /*Array(log.places)*/
            }
        }
    }
    
    func showSelectLogSheet(_ indexInfo: (String,Int)) {
        guard let ofLog = output.placeDict[indexInfo.0]?[indexInfo.1].ofLog else {
            return
        }
        output.showSelectLogSheet = output.showSelectLogSheet == .hidden ? .dynamic : .hidden
        output.ofLogList = Array(ofLog)
    }
    
    func showSaveImageSheet(_ image: UIImage) {
        output.fourCutImage = image
        output.showSaveFourCutSheet = output.showSaveFourCutSheet == .hidden ? .dynamic : .hidden
    }
    
    func deletelog(id: ObjectId) {
        guard let log = repository.fetchItem(object: Log.self, primaryKey: id) else {
            return
        }
        output.timeline.removeAll(where: {$0.id == log.id })
        log.places.forEach { place in
            output.placeDict[place.city]?.removeAll(where: {$0.id == place.id })
        }
        output.ofLogList.removeAll(where: {$0.id == log.id })
        output.$logList.remove(log)
    }
    
}
