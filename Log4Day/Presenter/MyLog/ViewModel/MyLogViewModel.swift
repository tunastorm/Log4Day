//
//  MyLogViewModel.swift
//  Log4Day
//
//  Created by 유철원 on 9/24/24.
//

import SwiftUI
import Combine
import RealmSwift

final class MyLogViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    
    @Published var output = Output()
    
    enum Action {
        case changeCategory
        case fetchFirstLastDate
        case fetchCategorizedList
        case fetchLogDate(isInitial: Bool)
        case tapBarChanged(info: TapInfo)
    }
    
    struct Input {
        let changeCategory = PassthroughSubject<Void, Never>()
        let fetchFirstLastDate = PassthroughSubject<Void, Never>()
        let fetchCategorizedList = PassthroughSubject<Void, Never>()
        let fetchLogDate = PassthroughSubject<Bool, Never>()
        let tapBarChanged = PassthroughSubject<TapInfo, Never>()
        var selectedCategory = ""
        var nowLogDate = DateFormatManager.shared.dateToFormattedString(date: Date(), format: .dotSeparatedyyyyMMddDay)
    }
    
    struct Output {
        var screenWidth = UIScreen.main.bounds.width
        var category = "전체"
        @ObservedResults(Log.self) var logList
        var timeline: [Log] = []
        var placeDict: [String:[Place]] = [:]
        var nonPhotoLogList: [Log] = []
        var firstLastDate: (String, String) = (DateFormatManager.shared.dateToFormattedString(date: Date(), format: .dotSeparatedyyyyMMddDay), "")
        var logDate: String = ""
        var selectedPicker: TapInfo = .timeline
        var translation: CGSize = .zero
        var offsetX: CGFloat = -120
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
                self?.fetchLogDate(isInitial)
            }
            .store(in: &cancellables)
        
        input.tapBarChanged
            .sink { [weak self] info in
                self?.fetchTapBarData(tapInfo: info)
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
        } else {
            output.$logList.where = { [weak self] in
                return $0.owner.title == self?.output.category ?? ""
            }
        }
        output.$logList.sortDescriptor = .init(keyPath: Log.Column.startDate.name, ascending: false)
        output.$logList.update()
        fetchFirstLastDate()
    }

    private func fetchLogDate(_ isInitial: Bool) {
        if isInitial, let nowLog = output.logList.first {
            input.nowLogDate = DateFormatManager.shared.dateToFormattedString(date: nowLog.startDate, format: .dotSeparatedyyyyMMddDay)
        }
        output.logDate = input.nowLogDate
    }

    private func fetchTapBarData(tapInfo: TapInfo) {
        output.selectedPicker = tapInfo
        switch tapInfo {
        case .timeline:
            output.timeline = output.logList.sorted { $0.startDate > $1.startDate }
        case .place:
            output.logList.forEach { log in
                guard let city = log.places.first?.city else {
                    print(#function, "도시 정보 없음")
                    return
                }
                if !output.placeDict.keys.contains(city) {
                    output.placeDict[city] = []
                    print("\(city) 추가됨")
                }
                output.placeDict[city]? = Array(log.places)
            }
        case .waited:
            output.nonPhotoLogList = output.logList.filter { $0.fourCut.isEmpty }
        }
    }
    
}
