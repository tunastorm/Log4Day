//
//  CategoryViewModel.swift
//  Log4Day
//
//  Created by 유철원 on 9/22/24.
//

import SwiftUI
import Combine
import RealmSwift

final class CategoryViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    private let repository = Repository.shared
    var input = Input()
    
    @Published var output = Output()
    
    enum Action {
        case fetchFirstLastDate
        case fetchCategorizedList
        case fetchLogDate(isInitial: Bool)
        case sideBarButtonTapped
        case changeTapped
        case tapBarChanged(info: TapInfo)
        case addTapped
        case deleteTapped
    }
    
    struct Input {
        let fetchFirstLastDate = PassthroughSubject<Void, Never>()
        let fetchCategorizedList = PassthroughSubject<Void, Never>()
        let fetchLogDate = PassthroughSubject<Bool, Never>()
        let sideBarButtonTapped = PassthroughSubject<Void, Never>()
        let changeTapped = PassthroughSubject<Void, Never>()
        let tapBarChanged = PassthroughSubject<TapInfo, Never>()
        let addTapped = PassthroughSubject<Void, Never>()
        let deleteTapped = PassthroughSubject<Void,Never>()
        var selectedCategory = ""
        var nowLogDate = ""
    }
    
    struct Output {
        var screenWidth = UIScreen.main.bounds.width
        var category = "전체"
        @ObservedResults(Category.self) var categoryList
        @ObservedResults(Log.self) var logList
        var timeline: [Log] = []
        var placeList: [Place] = []
        var nonPhotoLogList: [Log] = []
        var firstLastDate: (String, String) = ("", "")
        var logDate: String = ""
        var showSide = false
        var translation: CGSize = .zero
        var offsetX: CGFloat = -120
        var deleteAlert: Bool = false
        var addAlert: Bool = false
    }
    
    init() {
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
        
        input.changeTapped
            .sink { [weak self] category in
                self?.changeCategory()
            }
            .store(in: &cancellables)
        
        input.tapBarChanged
            .sink { [weak self] info in
                self?.fetchTapBarData(tapInfo: info)
            }
            .store(in: &cancellables)
        
        input.sideBarButtonTapped
            .sink { [weak self] _ in
                self?.toggleShowSide()
            }
            .store(in: &cancellables)
        
        input.addTapped
            .sink { [weak self] _ in
                self?.addCategory()
            }
            .store(in: &cancellables)
        
        input.deleteTapped
            .sink { [weak self] _ in
                self?.deleteCategory()
            }
            .store(in: &cancellables)
    }
    
    func action(_ action: Action) {
        switch action {
        case .fetchFirstLastDate:
            input.fetchFirstLastDate.send(())
        case .fetchCategorizedList:
            input.fetchCategorizedList.send(())
        case .fetchLogDate(let isInitial):
            input.fetchLogDate.send(isInitial)
        case .changeTapped:
            input.changeTapped.send(())
        case .tapBarChanged(let info):
            input.tapBarChanged.send(info)
        case .sideBarButtonTapped:
            input.sideBarButtonTapped.send(())
        case .addTapped:
            input.addTapped.send(())
        case .deleteTapped:
            input.deleteTapped.send(())
        }
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
        print(#function, "logCount:", output.logList.count)
        guard let log = output.logList.first else {
            return
        }
        let category = output.category
        if category == "전체" {
            output.$logList.where = { $0.createdAt <= Date() }
        } else {
            output.$logList.where = { $0.owner.title == category }
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
        switch tapInfo {
        case .timeline:
            output.timeline = output.logList.sorted { $0.startDate > $1.startDate }
        case .place:
            output.placeList = output.logList.flatMap { $0.places }.sorted { $0.city > $1.city }
        case .waited:
            output.nonPhotoLogList = output.logList.filter { $0.fourCut.isEmpty }
        }
    }
    
    private func changeCategory() {
        output.category = input.selectedCategory
    }
    
    private func toggleShowSide() {
        output.showSide.toggle()
    }
    
    private func addCategory() {
        
    }
    
    private func deleteCategory() {
        
    }
    
}
