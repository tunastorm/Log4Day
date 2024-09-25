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
    @State private var coord: (CLLocationDegrees, CLLocationDegrees) = (126.9784147, 37.5666805)
    @StateObject private var viewModel = NewLogViewModel()
    
    var body: some View {
        
        GeometryReader { proxy in
            
            ZStack {
                contentView()
            }
            
        }
        
    }
    
    private func contentView() -> some View {
        
        VStack {
            NavigationBar<Text>(title: "NewLog")
            ScrollView {
                titleView()
                LogDetailMapView(coord: $coord)
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
//            if viewModel.output.placeList.count > 0 {
//                Rectangle()
//                    .frame(height: 1)
//                    .frame(maxWidth: .infinity)
//                    .foregroundStyle(Resource.ciColor.subContentColor)
//            }
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
                        .foregroundStyle(Resource.ciColor.highlightColor)
                }
                .padding()
            }
            HStack {
                Spacer()
                NavigationLink {
                    SearchPlaceView(newLogViewModel: viewModel)
                } label: {
                    Text("추가")
                        .foregroundStyle(Resource.ciColor.highlightColor)
                }
                .frame(width: 100, height: 40)
                .background(.white)
                .cornerRadius(10, style: .continuous)
                .border(cornerRadius: 18, stroke: .init(Resource.ciColor.subContentColor.opacity(0.2), lineWidth:2))
                if viewModel.output.placeList.count > 0 {
                    Spacer()
                    Button("삭제") {
                        viewModel.action(.deleteButtonTapped(lastOnly: false))
                    }
                    .frame(width: 100, height: 40)
                    .background(.white)
                    .border(cornerRadius: 18, stroke: .init(Resource.ciColor.subContentColor.opacity(0.2), lineWidth:2))
                    .foregroundStyle(Resource.ciColor.subContentColor)
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
