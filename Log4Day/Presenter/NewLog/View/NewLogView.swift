//
//  WriteLogView.swift
//  Log4Day
//
//  Created by 유철원 on 9/23/24.
//

import SwiftUI
import NMapsMap
import BottomSheet

struct NewLogView: View {
    
    // 기본 위치 서울역
    @ObservedObject var categoryViewModel: CategoryViewModel
    @StateObject private var viewModel = LogDetailViewModel()
    
    @FocusState private var titleFocused: Bool
    @FocusState private var addSheetIsFocused: Bool
    
    var body: some View {
        
        GeometryReader { proxy in
            ZStack {
                contentView()
            }
            .onTapGesture {
                titleFocused = false
            }
        }
        .bottomSheet(bottomSheetPosition: $categoryViewModel.output.showAddSheet,
                     switchablePositions: [.dynamic]) {
            AddCategorySheet(isFocused: _addSheetIsFocused, viewModel: categoryViewModel)
        }
        .enableSwipeToDismiss()
        
    }
    
    private func contentView() -> some View {
        VStack {
            NavigationBar(
                title: "NewLog",
                button: Button {
                    viewModel.action(.createLog)
                } label: {
                    Text("등록")
                        .foregroundStyle(ColorManager.shared.ciColor.highlightColor)
                }
            )
            ScrollView {
                titleView()
                LogNaverMapView(isFull: false,
                                isDeleteMode: $viewModel.output.isDeleteMode, 
                                cameraPointer: $viewModel.output.cameraPointer,
                                placeList:  $viewModel.output.placeList,
//                                photoDict: $viewModel.output.photoDict, 
                                imageDict: $viewModel.output.imageDict,
                                coordinateList: $viewModel.output.coordinateList
                )
                placeButton()
                placeList()
            }
        }
        
    }

    private func titleView() -> some View {
        
        VStack() {
            HStack {
                VStack(alignment: .leading) {
                    CategoryPickerView(categoryViewModel: categoryViewModel, viewModel: viewModel)
                    TextField("제목을 입력하세요", text: $viewModel.input.title)
                        .font(.title3)
                        .focused($titleFocused)
                    Text(DateFormatManager.shared.dateToFormattedString(date: viewModel.output.date,
                                                                        format: .dotSeparatedyyyyMMddDay))
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
                .padding(.leading)
                .padding(.vertical)
                Spacer()
            }
            
        }
        
    }
    
    private func placeList() -> some View {
        LazyVStack {
            ForEach(viewModel.output.placeList.indices, id: \.self) { index in
                LogDetailPlaceCell(controller: .newLogView, viewModel: viewModel,
                                indexInfo: (index, viewModel.output.placeList.count),
                                place: viewModel.output.placeList[index])
            }
        }
        .background(.clear)
        .frame(maxWidth: .infinity)
        .padding()
        
    }
    
    private func placeButton() -> some View {
        VStack {
            if viewModel.output.placeList.isEmpty {
                HStack {
                    Text("오늘의 추억이 남은 장소를 추가해 보세요")
                        .foregroundStyle(ColorManager.shared.ciColor.highlightColor)
                }
                .padding()
            }
            HStack {
                Spacer()
                NavigationLink {
                    SearchPlaceView(newLogViewModel: viewModel)
                } label: {
                    Text("추가")
                        .foregroundStyle(viewModel.output.isDeleteMode ? 
                                         ColorManager.shared.ciColor.subContentColor : ColorManager.shared.ciColor.highlightColor)
                }
                .frame(width: 130, height: 40)
                .border(cornerRadius: 5, stroke: .init(ColorManager.shared.ciColor.subContentColor.opacity(0.2), lineWidth:2))
                .disabled(viewModel.output.isDeleteMode)
                
                if viewModel.output.placeList.count > 0 {
                    Button( viewModel.output.isDeleteMode ? "선택 삭제" : "삭제") {
                        if viewModel.output.isDeleteMode {
                            viewModel.action(.deleteButtonTapped(lastOnly: false))
                            viewModel.output.isDeleteMode = false
                        } else {
                            viewModel.output.cameraPointer = 0
                            viewModel.output.isDeleteMode = true
                        }
                    }
                    .frame(width: 130, height: 40)
                    .border(cornerRadius: 5, stroke: .init(ColorManager.shared.ciColor.subContentColor.opacity(0.2), lineWidth:2))
                    .foregroundStyle(viewModel.output.isDeleteMode ?
                                     ColorManager.shared.ciColor.highlightColor : ColorManager.shared.ciColor.subContentColor)
                    .padding(.leading, 10)
                }
                Spacer()
            }
            .padding(.top)
        }
    }
    
}
