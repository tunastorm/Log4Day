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
        case showAddSheet
        case showDeleteAlert
        case validate
        case addTapped
        case deleteTapped
        case newCategoryTextFieldReturn
    }
    
    struct Input {
        let sideBarButtonTapped = PassthroughSubject<Void, Never>()
        let changeTapped = PassthroughSubject<Void, Never>()
        let showAddSheet = PassthroughSubject<Void, Never>()
        let showDeleteAlert = PassthroughSubject<Void,Never>()
        let validate = PassthroughSubject<Void, Never>()
        let addTapped = PassthroughSubject<Void, Never>()
        let deleteTapped = PassthroughSubject<Void, Never>()
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
        var inValid = true
        var deleteAlert: Bool = false
        var addAlert: Bool = false
        var deleteResult: RepositoryResult
        var addResult: RepositoryResult
    }
    
    init() {
        input.sideBarButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.toggleShowSide()
            }
            .store(in: &cancellables)
        
        input.changeTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.changeCategory()
            }
            .store(in: &cancellables)
        
        input.showAddSheet
            .withUnretained(self)
            .sink { owner, _ in
                owner.showAddSheet()
            }
            .store(in: &cancellables)
        
        input.showDeleteAlert
            .withUnretained(self)
            .sink { owner, _ in
                owner.showDeleteAlert()
            }
            .store(in: &cancellables)
        
        input.validate
            .withUnretained(self)
            .sink { owner, _ in
                owner.validation()
            }
            .store(in: &cancellables)
        
        input.addTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.addCategory()
            }
            .store(in: &cancellables)
        
        input.deleteTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.deleteCategory()
            }
            .store(in: &cancellables)
        
        input.newCategoryTextFieldReturn
            .withUnretained(self)
            .sink { owner, _ in
                owner.addCategory()
            }
            .store(in: &cancellables)
    }
    
    func action(_ action: Action) {
        switch action {
        case .sideBarButtonTapped:
            input.sideBarButtonTapped.send(())
        case .changeTapped:
            input.changeTapped.send(())
        case .showAddSheet:
            input.showAddSheet.send(())
        case .showDeleteAlert:
            input.showDeleteAlert.send(())
        case .validate:
            input.validate.send(())
        case .addTapped:
            input.addTapped.send(())
        case .deleteTapped:
            input.deleteTapped.send(())
        case .newCategoryTextFieldReturn:
            input.newCategoryTextFieldReturn.send(())
        }
    }

    private func changeCategory() {
        output.category = input.selectedCategory
    }
    
    private func toggleShowSide() {
        output.showSide.toggle()
    }
    
    private func showAddSheet() {
        output.showAddSheet = output.showAddSheet == .hidden ? .dynamic : .hidden
    }
    
    private func showAddAlert() {
        output.addAlert.toggle()
    }
    
    private func showDeleteAlert() {
        output.deleteAlert.toggle()
    }
    
    private func validation() {
        let isExist = output.categoryList.map { $0.title }.contains(input.newCategory)
        output.inValid = isExist || input.newCategory.isEmpty || input.newCategory.count > 7
    }
    
    private func addCategory() {
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
        input.newCategory = ""
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
