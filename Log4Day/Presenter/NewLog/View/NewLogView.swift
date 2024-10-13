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
import SwiftUIX

struct NewLogView: View {
    
    @Binding var tapSelection: Int
    
    // 기본 위치 서울역
    @ObservedObject var categoryViewModel: CategoryViewModel
    @StateObject private var viewModel = LogDetailViewModel()
    
    @State private var showPicker: Bool = false
    @State private var showCanclePicker: Bool = false
    @State private var cancelList: [Int] = []
    
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
                LoadingView(loadingState: $viewModel.output.loadingState)
            }
            .onTapGesture {
                if titleFocused {
                    viewModel.action(.validate)
                    titleFocused = false
                }
            }
        }
        .onAppear {
            viewModel.action(.validate)
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
                title: viewModel.output.placeList.count > 0 && 
                       viewModel.output.cameraPointer >= 0 &&
                       viewModel.output.cameraPointer < viewModel.output.placeList.count ?
                       viewModel.output.placeList[viewModel.output.cameraPointer].name : ""
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
                            viewModel.output.showPlaceEditSheet = .hidden
                            tapSelection = 0
                        } label: {
                            Text("등록")
                                .foregroundStyle(viewModel.output.inValid ?
                                                 ColorManager.shared.ciColor.subContentColor : ColorManager.shared.ciColor.highlightColor)
                        }
                        .disabled(viewModel.output.inValid)
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
        .sheet(isPresented: $showCanclePicker, content: {
            deleteImageSheet()
        })
    }

    private func titleView() -> some View {
        VStack() {
            HStack {
                VStack(alignment: .leading) {
                    CategoryPickerView(categoryViewModel: categoryViewModel, viewModel: viewModel)
                    TextField("오늘의 추억을 요약해보세요 (최대 15자)", text: $viewModel.input.title)
                        .font(.title3)
                        .foregroundStyle(viewModel.output.inValid ? .gray : .black)
                        .focused($titleFocused)
                        .onSubmit {
                            viewModel.action(.validate)
                        }
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
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                Section(header: PlaceListHeader(viewModel: viewModel)) {
                    ForEach(viewModel.output.placeList.indices, id: \.self) { index in
                        LogDetailPlaceCell(controller: .newLogView, viewModel: viewModel,
                                        indexInfo: (index, viewModel.output.placeList.count),
                                        place: viewModel.output.placeList[index])
                    }
                }
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
                    Text("장소와 사진을 추가해\n오늘 하루를 네컷 사진으로 기록하세요")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(ColorManager.shared.ciColor.highlightColor)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            HStack {
                Spacer()
                NavigationLink {
                    SearchPlaceView(newLogViewModel: viewModel)
                } label: {
                    Text("장소 추가")
                        .foregroundStyle(ColorManager.shared.ciColor.highlightColor)
                }
                .frame(width: 130, height: 40)
                .border(cornerRadius: 5, stroke: .init(ColorManager.shared.ciColor.subContentColor.opacity(0.2), lineWidth:2))
    
                if viewModel.output.placeList.count > 0 {
                    Button("장소 삭제") {
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
                    showPicker.toggle()
                } label: {
                    Text("사진 추가")
                }
                .disabled(viewModel.output.imageDict.values.flatMap({ $0 }).count >= 4)
                .frame(width: 130, height: 40)
                .border(cornerRadius: 5, stroke: .init(ColorManager.shared.ciColor.subContentColor.opacity(0.2), lineWidth:2))
                .foregroundStyle(ColorManager.shared.ciColor.highlightColor)
                Spacer()
                Button {
                    showCanclePicker.toggle()
                } label: {
                    Text("사진 편집")
                }
                .disabled(viewModel.output.imageDict[viewModel.output.cameraPointer]?.count ?? 0 < 1)
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
    
    private func deleteImageSheet() -> some View {
        let imageList = viewModel.output.imageDict[viewModel.output.cameraPointer] ?? []
        return VStack {
            HStack {
                Button {
                    showCanclePicker.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .frame(width: 40, height: 40)
                }
                .padding(.top)
                .padding(.horizontal)
                Text("사진 선택 \(cancelList.count) / \(imageList.count)")
                    .padding(.top)
                Spacer()
            }
            Rectangle()
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
            if viewModel.output.placeList.count > 0 {
                ScrollView(.horizontal) {
                    LazyHStack(alignment: .center) {
                        ForEach(imageList.indices, id: \.self) { index in
                            ZStack {
                                VisualEffectBlurView(blurStyle: .systemChromeMaterial, vibrancyStyle: .fill) { }
                                .frame(width: 300, height: 500)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 0, style: .continuous)
                                        .stroke(lineWidth: 1)
                                        .fill(Color.white)
                                )
                                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 4)
                                .padding()
                                .blendMode(.luminosity)
                                VStack(alignment: .center) {
                                    Image(uiImage: imageList[index])
                                        .resizable()
                                        .frame(width: 280, height: 480)
                                        .padding(10)
                                }
                                .overlay {
                                    Rectangle()
                                        .stroke(lineWidth:cancelList.contains(index) ? 10 : 0)
                                        .fill(Color.systemMint)
                                        .frame(width: 290, height: 490)
                                }
                            }
                            .padding(.horizontal)
                            .onPress {
                                if viewModel.input.editImages.contains(index) {
                                    viewModel.input.editImages.removeAll(where: {$0 == index})
                                    cancelList.removeAll(where: {$0 == index})
                                } else {
                                    viewModel.input.editImages.append(index)
                                    cancelList.append(index)
                                }
                            }
                        }
                    }
                }
                .hideIndicator()
                .padding(.vertical)
                VStack(alignment: .center) {
                    Button {
                        if viewModel.input.editImages.count > 0 {
                            viewModel.action(.editPickedImages)
                            cancelList.removeAll()
                        }
                        showCanclePicker.toggle()
                    } label: {
                        Text("삭제하기")
                            .foregroundStyle(.white)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(ColorManager.shared.ciColor.highlightColor)
                            .cornerRadius(10, corners: .allCorners)
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                }
    
            }
            
        }
    }
    
}
