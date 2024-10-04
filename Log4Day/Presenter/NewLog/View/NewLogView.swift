//
//  WriteLogView.swift
//  Log4Day
//
//  Created by 유철원 on 9/23/24.
//

import SwiftUI
import NMapsMap
import BottomSheet
import PhotosUI

struct NewLogView: View {
    
    @Binding var tapSelection: Int
    
    // 기본 위치 서울역
    @ObservedObject var categoryViewModel: CategoryViewModel
    @StateObject private var viewModel = LogDetailViewModel()
    
    @State private var isInValid = true
    @State private var showPicker: Bool = false
    
    @FocusState private var titleFocused: Bool
    @FocusState private var addSheetIsFocused: Bool
    
    var pickerConfig: (Int) -> PHPickerConfiguration = { limit in
          var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
          config.filter = .images
          config.selection = .ordered
          config.selectionLimit = limit
          config.preferredAssetRepresentationMode = .current // 트랜스 코딩을 방지
          return config
    }
    
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
        .bottomSheet(bottomSheetPosition: $viewModel.output.showPlaceEditSheet,
                     switchablePositions: [.dynamic]) {
            BottomSheetHeaderView(
                title: viewModel.output.placeList.count > 0 ? viewModel.output.placeList[viewModel.output.cameraPointer].name : ""
            )
        } mainContent: {
            if viewModel.output.placeList.count > 0 {
                editPlaceSheetView()
            }
        }
        .showDragIndicator(false)
        .enableContentDrag()
        .enableSwipeToDismiss()
        .enableTapToDismiss()
        .showCloseButton()
    }
    
    private func contentView() -> some View {
        ZStack {
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
                    LazyVStack {
                        titleView()
                        LogNaverMapView(isFull: false,
                                        cameraPointer: $viewModel.output.cameraPointer,
                                        placeList:  $viewModel.output.placeList,
                                        imageDict: $viewModel.output.imageDict,
                                        coordinateList: $viewModel.output.coordinateList
                        )
                        placeList()
                        placeButton()
                    }
                }
            }
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(.white)
                .opacity(viewModel.output.showPlaceEditSheet == .hidden ? 0 : 0.7)
        }
        .sheet(isPresented: $showPicker, content: {
            let limit = 4 - viewModel.output.imageDict.values.flatMap{ $0 }.count
            PhotoPicker(
                viewModel: viewModel,
                isPresented: $showPicker,
                configuration: pickerConfig(limit)
            )
            .ignoresSafeArea()
        })
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
//            if !viewModel.output.placeList.isEmpty {
//                VStack {
//                    HStack {
//                        Text("포토")
//                            .padding(.leading, 5)
//                            .padding(.trailing, 20)
//                        Text("플레이스")
//                        Spacer()
//                    }
//                    Rectangle()
//                        .frame(height: 1)
//                        .frame(maxWidth: .infinity)
//                }
//                .foregroundStyle(ColorManager.shared.ciColor.highlightColor)
//            }
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
            .padding(.bottom)
        }
    }
    
    private func editPlaceSheetView() -> some View {
        let place = viewModel.output.placeList[viewModel.output.cameraPointer]
        return VStack(alignment: .center) {
            VStack {
//                HStack {
//                    Text(place.name)
//                        .font(.title3)
//                        .bold()
//                        .foregroundStyle(ColorManager.shared.ciColor.contentColor)
//                    Spacer()
//                }
                HStack {
                    Text(place.address)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
                    Spacer()
                }
            }
            .padding(.top, 20)
            .padding(.horizontal)
            HStack {
                Spacer()
                Button {
                    if viewModel.output.imageDict.values.flatMap({ $0 }).count < 4 {
                        showPicker.toggle()
                    }
                } label: {
                    Text("사진 추가")
                }
                .frame(width: 130, height: 40)
                .border(cornerRadius: 5, stroke: .init(ColorManager.shared.ciColor.subContentColor.opacity(0.2), lineWidth:2))
                .foregroundStyle(ColorManager.shared.ciColor.highlightColor)
                Spacer()
                Button {
                    
                } label: {
                    Text("사진 삭제")
                }
                .frame(width: 130, height: 40)
                .border(cornerRadius: 5, stroke: .init(ColorManager.shared.ciColor.subContentColor.opacity(0.2), lineWidth:2))
                .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
                Spacer()
            }
            .padding(.top, 20)
            .padding(.horizontal)
            Spacer()
        }
        .frame(height: 250)
        .frame(maxWidth: .infinity)
        .background(.white)
    }
    
}
