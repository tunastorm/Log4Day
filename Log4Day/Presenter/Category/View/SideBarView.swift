//
//  SideBarView.swift
//  Log4Day
//
//  Created by 유철원 on 9/20/24.
//

import SwiftUI
import RealmSwift
import BottomSheet

struct SideBarView: View {
    
    var controller: Controller
    
    @ObservedObject var viewModel: CategoryViewModel
    @EnvironmentObject private var myLogViewModel: MyLogViewModel
    @EnvironmentObject private var logMapViewModel: LogMapViewModel
    
    @FocusState var addSheetIsEditing: Bool
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .opacity(viewModel.output.showSide ? 0.7 : 0)
                    .onTapGesture {
                        withAnimation {
                            viewModel.action(.sideBarButtonTapped)
                            if viewModel.output.showAddSheet != .hidden {
                                viewModel.action(.addTapped)
                                addSheetIsEditing = false
                            }
                        }
                    }
                HStack {
                    switch controller {
                    case .myLog:
                        SideView(controller: controller, viewModel: viewModel)
                            .environmentObject(myLogViewModel)
                    case .logMap:
                        SideView(controller: controller, viewModel: viewModel)
                            .environmentObject(logMapViewModel)
                    default: Text("")
                    }
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.clear)
                }
            }
            .bottomSheet(bottomSheetPosition: $viewModel.output.showAddSheet, switchablePositions: [.hidden, .dynamic]) {
                BottomSheetHeaderView(title: "카테고리 추가")
            } mainContent: {
                AddCategorySheet(isFocused: _addSheetIsEditing, viewModel: viewModel)
            }
            .showDragIndicator(false)
            .enableContentDrag()
            .enableSwipeToDismiss()
            .enableTapToDismiss()
            .showCloseButton()
        }
    }
    
}
