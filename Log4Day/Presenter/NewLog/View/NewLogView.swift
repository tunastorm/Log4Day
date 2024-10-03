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
    
    @Binding var tapSelection: Int
    
    // 기본 위치 서울역
    @ObservedObject var categoryViewModel: CategoryViewModel
    @StateObject private var viewModel = LogDetailViewModel()
    
    @State private var isInValid = true
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
                     switchablePositions: [.hidden, .dynamic]) {
            BottomSheetHeaderView(title: "카테고리 추가")
        } mainContent: {
            AddCategorySheet(isFocused: _addSheetIsFocused, viewModel: categoryViewModel)
        }
        .showDragIndicator(false)
        .enableContentDrag()
        .enableSwipeToDismiss()
        .enableTapToDismiss()
        .showCloseButton()
    }
    
    private func contentView() -> some View {
        VStack {
            NavigationBar(
                title: "NewLog",
                button: Button {
                        viewModel.action(.createLog)
                        tapSelection = 0
                    } label: {
                        Text("등록")
                            .foregroundStyle(isInValid ?
                                             ColorManager.shared.ciColor.subContentColor : ColorManager.shared.ciColor.highlightColor)
                    }
                    .disabled(isInValid)
            )
            ScrollView {
                titleView()
                LogNaverMapView(isFull: false,
                                cameraPointer: $viewModel.output.cameraPointer,
                                placeList:  $viewModel.output.placeList,
                                imageDict: $viewModel.output.imageDict,
                                coordinateList: $viewModel.output.coordinateList
                )
                placeButton()
                placeList()
            }
        }
        .onChange(
            of: viewModel.input.title.isEmpty ||
                viewModel.input.title.replacingOccurrences(of: " ", with: "") == ""
        ) { self.isInValid = $0 }
        
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
        VStack {
            if !viewModel.output.placeList.isEmpty {
                VStack {
                    HStack {
                        Text("사진")
                            .padding(.leading, 5)
                            .padding(.trailing, 20)
                        Text("플레이스")
                        Spacer()
                    }
                    Rectangle()
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                }
                .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
            }
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
                    Text("추억이 남은 장소를 추가해 보세요")
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
                        .foregroundStyle(ColorManager.shared.ciColor.highlightColor)
                }
                .frame(width: 130, height: 40)
                .border(cornerRadius: 5, stroke: .init(ColorManager.shared.ciColor.subContentColor.opacity(0.2), lineWidth:2))
                
                if viewModel.output.placeList.count > 0 {
                    Button("삭제") {
                        viewModel.action(.deleteButtonTapped(lastOnly: false))
                    }
                    .frame(width: 130, height: 40)
                    .border(cornerRadius: 5, stroke: .init(ColorManager.shared.ciColor.subContentColor.opacity(0.2), lineWidth:2))
                    .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
                    .padding(.leading, 10)
                }
                Spacer()
            }
            .padding(.top)
        }
    }
    
}
