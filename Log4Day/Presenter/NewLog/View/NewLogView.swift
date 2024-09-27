//
//  WriteLogView.swift
//  Log4Day
//
//  Created by 유철원 on 9/23/24.
//

import SwiftUI
import NMapsMap

struct NewLogView: View {
    
    // 기본 위치 서울역
    @StateObject private var viewModel = NewLogViewModel()
    
    @FocusState private var titleFocused: Bool
    
    var body: some View {
        
        GeometryReader { proxy in
            ZStack {
                contentView()
            }
            .onTapGesture {
                titleFocused = false
            }
        }
        
    }
    
    private func contentView() -> some View {
        
        VStack {
            NavigationBar(
                title: "NewLog",
                button: Button {
                    print("등록 클릭")
                } label: {
                    Text("등록")
                        .foregroundStyle(ColorManager.shared.ciColor.highlightColor)
                }
            )
            ScrollView {
                titleView()
                LogNaverMapView(isFull: false, 
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
                    TextField("제목을 입력하세요", text: $viewModel.input.title)
                        .font(.title3)
                        .focused($titleFocused)
                    Text(DateFormatManager.shared.dateToFormattedString(date: Date(), format: .dotSeparatedyyyyMMddDay))
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
                .padding(.leading)
                .padding(.vertical)
                Spacer()
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.output.tagList, id: \.self) { item in
                        HashTagCell(hashTag: item)
                    }
                }
                .padding(.horizontal)
            }
        }
        
    }
    
    private func placeList() -> some View {
        LazyVStack {
            ForEach(viewModel.output.placeList.indices, id: \.self) { index in
                NewLogPlaceCell(viewModel: viewModel,
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
                if viewModel.output.placeList.count > 0 {
                    Button("삭제") {
                        if viewModel.output.isDeleteMode {
                            viewModel.action(.deleteButtonTapped(lastOnly: false))
                            viewModel.output.isDeleteMode = false
                        } else {
                            viewModel.output.isDeleteMode = true
                            viewModel.output.cameraPointer = 0
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

#Preview {
    NewLogView()
}
