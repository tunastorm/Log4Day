//
//  LogDetail.swift
//  Log4Day
//
//  Created by 유철원 on 9/20/24.
//

import SwiftUI
import NMapsMap
import RealmSwift

struct LogDetailView: View {
    
    var logId: ObjectId
    
    @ObservedObject var categoryViewModel: CategoryViewModel
    @ObservedObject var myLogViewModel: MyLogViewModel
    @StateObject private var viewModel = LogDetailViewModel()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FocusState private var titleFocused: Bool
    @FocusState private var addSheetIsFocused: Bool
    
    var body: some View {
        NavigationWrapper {
            Menu {
               Button {
                   viewModel.action(.updateLog(id: logId))
                   myLogViewModel.action(.changeCategory)
               } label: {
                   Label(
                       title: { Text("수정") },
                       icon: { Image(systemName: "pencil")}
                   )
               }
               Button {
                   myLogViewModel.action(.deleteLog(id: logId))
                   presentationMode.wrappedValue.dismiss()
               } label: {
                   Label(
                       title: { Text("삭제") },
                       icon: { Image(systemName: "xmark.circle")
                              
                       }
                   )
                   .foregroundStyle(.red)
               }
           } label: {
               Image(systemName: "square.and.pencil")
                   .foregroundStyle(.black)
           }
        } content: {
            GeometryReader { proxy in
                ZStack {
                    if proxy.size != .zero {
                        contentView()
                    }
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
        } dismissHandler: { }
        .onAppear {
            viewModel.action(.setLog(id: logId))
        }
    }
    
    private func contentView() -> some View {
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
//                placeButton()
            }
        }
    }

    private func titleView() -> some View {
        VStack() {
            HStack {
                VStack(alignment: .leading) {
                    CategoryPickerView(categoryViewModel: categoryViewModel, viewModel: viewModel)
                    TextField("", text: $viewModel.input.title)
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

    private func placeButton() -> some View {
        VStack {
            if viewModel.output.placeList.isEmpty {
                HStack {
                    Text("오늘의 추억이 남은 장소를 추가해 보세요")
                        .foregroundStyle(ColorManager.shared.ciColor.highlightColor)
                }
                .padding()
            } else {
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
    
    private func placeList() -> some View {
        VStack {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                Section(header: PlaceListHeader(viewModel: viewModel)) {
                    ForEach(viewModel.output.placeList.indices, id: \.self) { index in
                        LogDetailPlaceCell(
                            controller: .logDetail, 
                            viewModel: viewModel,
                            indexInfo: (index, viewModel.output.placeList.count),
                            place: viewModel.output.placeList[index]
                        )
                    }
                }
            }
        }
        .background(.clear)
        .frame(maxWidth: .infinity)
        .padding()
    }
    
}

struct HashTagCell: View {
    
    var hashTag: String
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 15)
                .frame(height: 30)
                .frame(minWidth: 40)
                .foregroundStyle(ColorManager.shared.ciColor.highlightColor)
            Text("#\(hashTag)")
                .foregroundStyle(.white)
                .font(.callout)
                .padding(.horizontal, 6)
        }
    }
    
}
