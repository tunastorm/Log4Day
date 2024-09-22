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
        case fetchFilteredList
        case sideBarButtonTapped
        case changeTapped
        case addTapped
        case deleteTapped
    }
    
    struct Input {
        let fetchFilteredList = PassthroughSubject<Void, Never>()
        let sideBarButtonTapped = PassthroughSubject<Void, Never>()
        let changeTapped = PassthroughSubject<Void, Never>()
        let addTapped = PassthroughSubject<Void, Never>()
        let deleteTapped = PassthroughSubject<Void,Never>()
        var selectedCategory = ""
    }
    
    struct Output {
        var category = "전체"
        @ObservedResults(Category.self) var categoryList
        @ObservedResults(Log.self) var logList
        var showSide = false
        var translation: CGSize = .zero
        var offsetX: CGFloat = -120
        var deleteAlert: Bool = false
        var addAlert: Bool = false
    }
    
    init() {
        input.fetchFilteredList
            .sink { [weak self] _ in
                self?.fetchFilteredLogList()
            }
            .store(in: &cancellables)
        
        input.changeTapped
            .sink { [weak self] category in
                self?.changeCategory()
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
        case .fetchFilteredList:
            input.fetchFilteredList.send(())
        case .changeTapped:
            input.changeTapped.send(())
        case .sideBarButtonTapped:
            input.sideBarButtonTapped.send(())
        case .addTapped:
            input.addTapped.send(())
        case .deleteTapped:
            input.deleteTapped.send(())
        }
    }
    
    private func fetchFilteredLogList() {
        print(#function, "logCount:", output.logList.count)
        guard output.category != "전체", let log = output.logList.first else {
            print("오너 없음")
            return
        }
        let category = output.category        
        output.$logList.where = { $0.owner.title == category }
        output.$logList.update()
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
