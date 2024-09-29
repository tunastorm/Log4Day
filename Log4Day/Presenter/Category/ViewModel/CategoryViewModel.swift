//
//  CategoryViewModel.swift
//  Log4Day
//
//  Created by 유철원 on 9/22/24.
//

import SwiftUI
import Combine
import RealmSwift
import BottomSheet

class CategoryViewModel: ObservableObject {
    
    private let repository = Repository.shared
    private var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output(deleteResult: RepositoryStatus.idle,
                                   addResult: RepositoryStatus.idle)
    
    enum Action {
        case sideBarButtonTapped
        case changeTapped
        case addTapped
        case deleteTapped
        case addAlertTapped
        case deleteAlertTapped
        case newCategoryTextFieldReturn
    }
    
    struct Input {
        let sideBarButtonTapped = PassthroughSubject<Void, Never>()
        let changeTapped = PassthroughSubject<Void, Never>()
        let addTapped = PassthroughSubject<Void, Never>()
        let deleteTapped = PassthroughSubject<Void,Never>()
        let addAlertTapped = PassthroughSubject<Void, Never>()
        let deleteAlertTapped = PassthroughSubject<Void, Never>()
        let newCategoryTextFieldReturn = PassthroughSubject<Void, Never>()
        var selectedCategory = ""
        var nowLogDate = DateFormatManager.shared.dateToFormattedString(date: Date(), format: .dotSeparatedyyyyMMddDay)
        var newCategory = ""
    }
    
    struct Output {
        var category = "전체"
        @ObservedResults(Category.self) var categoryList
        var logDate: String = ""
        var showSide = false
        var showAddSheet: BottomSheetPosition = .hidden
        @FocusState var addCategoryTextFieldEditing: Bool
        var deleteAlert: Bool = false
        var addAlert: Bool = false
        var deleteResult: RepositoryResult
        var addResult: RepositoryResult
    }
    
    init() {
        input.sideBarButtonTapped
            .sink { [weak self] _ in
                self?.toggleShowSide()
            }
            .store(in: &cancellables)
        
        input.changeTapped
            .sink { [weak self] _ in
                self?.changeCategory()
            }
            .store(in: &cancellables)
        
        input.addTapped
            .sink { [weak self] _ in
                self?.showAddSheet()
            }
            .store(in: &cancellables)
        
        input.deleteTapped
            .sink { [weak self] _ in
                self?.showDeleteAlert()
            }
            .store(in: &cancellables)
        
        input.addAlertTapped
            .sink { [weak self] _ in
                self?.addCategory()
            }
            .store(in: &cancellables)
        
        input.deleteAlertTapped
            .sink { [weak self] _ in
                self?.deleteCategory()
            }
            .store(in: &cancellables)
        
        input.newCategoryTextFieldReturn
            .sink { [weak self] _ in
                self?.addCategory()
            }
            .store(in: &cancellables)
    }
    
    func action(_ action: Action) {
        switch action {
        case .sideBarButtonTapped:
            input.sideBarButtonTapped.send(())
        case .changeTapped:
            input.changeTapped.send(())
        case .addTapped:
            input.addTapped.send(())
        case .deleteTapped:
            input.deleteTapped.send(())
        case .addAlertTapped:
            input.addAlertTapped.send(())
        case .deleteAlertTapped:
            input.deleteAlertTapped.send(())
        case .newCategoryTextFieldReturn:
            input.newCategoryTextFieldReturn.send(())
        }
    }

    func changeCategory() {
        output.category = input.selectedCategory
    }
    
    func toggleShowSide() {
        output.showSide.toggle()
    }
    
    func showAddSheet() {
        output.showAddSheet = output.showAddSheet == .hidden ? .dynamic : .hidden
    }
    
    func showAddAlert() {
        output.addAlert.toggle()
    }
    
    func showDeleteAlert() {
        output.deleteAlert.toggle()
    }
    
    func addCategory() {
        let item = Category(title: input.newCategory)
        repository.createItem(item) { result in
            switch result {
            case .success(let status): 
                input.selectedCategory = input.newCategory
                action(.changeTapped)
                output.addResult = status
            case .failure(let error): output.addResult = error
            }
        }
    }
    
    func deleteCategory() {
        var item: Category?
        output.categoryList.enumerated().forEach { index, category in
            if category.title == output.category {
                let searched = output.categoryList[index]
                item = searched
            }
        }
        guard let item else { return }
        repository.deleteCategory(item) { [weak self] result in
            switch result {
            case .success(let status): self?.output.deleteResult = status
            case .failure(let error): self?.output.deleteResult = error
            }
        }
    }
}
