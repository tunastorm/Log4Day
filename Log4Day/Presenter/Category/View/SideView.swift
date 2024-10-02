//
//  SideView.swift
//  Log4Day
//
//  Created by 유철원 on 9/15/24.
//

import SwiftUI
import RealmSwift

struct SideView: View {
    
    var controller: Controller
    @Namespace var namespace
    @ObservedObject var viewModel: CategoryViewModel
    @EnvironmentObject var myLogViewModel: MyLogViewModel
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.white
            VStack {
                titleView()
                Spacer()
                categoryListView()
            }
        }
        .frame(width: 240)
        .frame(maxHeight: .infinity)
        .offset(x: viewModel.output.showSide ? 0 : -248, y: 0)
    }
    
    private func titleView() -> some View {
        VStack {
            HStack {
                Text("카테고리")
                    .font(.headline)
                    .foregroundColor(ColorManager.shared.ciColor.highlightColor)
                Spacer()
                Button {
                    withAnimation {
                        viewModel.action(.sideBarButtonTapped)
                    }
                } label: {
                    Image(systemName: "xmark")
                }
                .padding(.trailing)
                .foregroundStyle(ColorManager.shared.ciColor.contentColor)
            }
            .padding(.leading)
            .padding(.top)
            Rectangle()
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
        }
    }
    
    private func categoryListView() -> some View {
        VStack {
            ScrollView {
                SidebarButton(viewModel: viewModel, title: "전체", namespace: namespace , controller: controller)
                    .environmentObject(viewModel)
                ForEach(viewModel.output.categoryList, id: \.id) { item in
                    SidebarButton(viewModel: viewModel, title: item.title, namespace: namespace , controller: controller)
                        .environmentObject(viewModel)
                }
            }
            buttonView()
        }
    }
    
    private func buttonView() -> some View {
        HStack {
            deleteButton()
            Rectangle()
                .frame(width: 1)
                .frame(maxHeight: .infinity)
                .padding(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
            addButton()
        }
        .frame(height: 40)
        .frame(maxWidth: .infinity)
    }
    
    private func deleteButton() -> some View {
        Button {
            guard viewModel.output.category != "전체" else {
                // Toast 뷰 구현 가져와서 예외처리
                return
            }
            viewModel.action(.deleteTapped)
        } label: {
            Text("삭제하기")
                .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
        }
        .padding(.horizontal)
        .alert(LocalizedStringKey("'\(viewModel.output.category)' 카테고리를 삭제하시겠습니까?"), isPresented: $viewModel.output.deleteAlert) {
            Button("취소", role: .cancel) {
                
            }
            Button("삭제", role: .destructive) {
                viewModel.action(.deleteAlertTapped)
                deleteResultHandler()
            }
        }
    }
    
    private func addButton() -> some View {
        Button {
            viewModel.action(.addTapped)
        } label: {
            Text("추가하기")
        }
        .padding(.horizontal)
//        .halfSheet(showSheet: $viewModel.output.showAddSheet) {
//            AddCategorySheet(viewModel: viewModel)
//        } onEnd: {
//            print("Dismiss")
//        }
    }
    
    private func addResultHandler() {
        let result = viewModel.output.addResult
        switch result {
        case is RepositoryStatus:
            guard let status = result as? RepositoryStatus, status != .idle else { return }
            fetchSideBar(category: viewModel.output.category)
            switch controller {
            case .myLog: fetchMyLog(category: viewModel.output.category)
            case .logMap: fetchLogMap(category: viewModel.output.category)
            default: break
            }
        default: break
        }
    }
    
    private func deleteResultHandler() {
        let result = viewModel.output.deleteResult
        switch result {
        case is RepositoryStatus:
            guard let status = result as? RepositoryStatus, status != .idle else { return }
            fetchSideBar(category: "전체")
            switch controller {
            case .myLog: fetchMyLog(category: "전체")
            case .logMap: fetchLogMap(category: "전체")
            default: break
            }
        default: break
        }
    }
    
    private func fetchSideBar(category: String) {
        viewModel.input.selectedCategory = category
        viewModel.action(.changeTapped)
    }
    
    private func fetchMyLog(category: String) {
        myLogViewModel.input.selectedCategory = category
        myLogViewModel.action(.changeCategory)
        myLogViewModel.action(.fetchCategorizedList)
        myLogViewModel.action(.fetchFirstLastDate)
        myLogViewModel.action(.fetchLogDate(isInitial: true))
        myLogViewModel.action(.tapBarChanged(info: .timeline))
    }
    
    private func fetchLogMap(category: String) {
        
    }
    
}
