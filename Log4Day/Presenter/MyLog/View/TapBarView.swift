//
//  ScheduleListView.swift
//  Log4Day
//
//  Created by 유철원 on 9/20/24.
//

import SwiftUI
import BottomSheet

enum TapInfo : String, CaseIterable {
    case timeline = "타임라인"
    case place = "플레이스"
//    case waited = "작성중"
}

struct TapBarView: View {
    
    @ObservedObject var categoryViewModel: CategoryViewModel
    @EnvironmentObject var viewModel: MyLogViewModel
    @Namespace private var animation

    var body: some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            Section(header: TopTabbar(animation: animation)
                            .environmentObject(viewModel)
            ) {
                LazyVStack {
                    switch viewModel.output.selectedPicker {
                    case .timeline: timelineList()
                    case .place: placeList()
//                    case .waited: waitedList()
                    }
                }
                .background(.clear)
                .frame(maxWidth: .infinity)
                .padding()
            }
        }
        .onAppear {
            viewModel.action(.tapBarChanged(info: viewModel.output.selectedPicker))
        }
    }

    private func timelineList() -> some View {
        ForEach(viewModel.output.timeline.indices, id: \.self) { index in
            NavigationLink {
                NextViewWrapper(LogDetailView(log: viewModel.output.logList[index], categoryViewModel: categoryViewModel))
            } label: {
                TimelineCell(index: index, log: viewModel.output.timeline[index])
                    .environmentObject(viewModel)
            }
        }
    }
    
    private func placeList() -> some View {
        let keys = viewModel.output.placeDict.sorted { $0.key < $1.key }.map{ $0.key }
        return ForEach(keys, id: \.self) { key in
            VStack {
                HStack {
                    Text(key)
                        .font(.title2)
                        .foregroundStyle(ColorManager.shared.ciColor.highlightColor)
                    Spacer()
                }
                ForEach((viewModel.output.placeDict[key] ?? []).indices, id: \.self){ index in
                    Button {
                        viewModel.action(.placeCellTapped(indexInfo: (key, index)))
                    } label: {
                        PlaceCell(index: index, total: (viewModel.output.placeDict[key] ?? []).count, place: (viewModel.output.placeDict[key] ?? [])[index])
                    }
                }
            }
        }
    }
    
    private func waitedList() -> some View {
        ForEach(viewModel.output.nonPhotoLogList.indices, id: \.self) { index in
            
        }
    }

}

struct TopTabbar: View {
    
    @EnvironmentObject var viewModel: MyLogViewModel
    var animation: Namespace.ID
    
    var body: some View {
        ZStack(alignment: .bottom) {
            HStack {
                ForEach(TapInfo.allCases, id: \.self) { item in
                    VStack {
                        Text(item.rawValue)
                            .font(.headline)
                            .frame(maxWidth: .infinity/4, minHeight: 30)
                            .foregroundColor(viewModel.output.selectedPicker == item ?
                                .mint: .gray)
                            .padding(.horizontal)
                        if viewModel.output.selectedPicker == item {
                            Capsule()
                                .foregroundColor(ColorManager.shared.ciColor.highlightColor)
                                .frame(height: 3)
                                .matchedGeometryEffect(id: "info", in: animation)
                                .padding(.horizontal)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            viewModel.action(.tapBarChanged(info: item))
                        }
                    }
                }
            }
        }
        .background(ColorManager.shared.ciColor.backgroundColor)
    }
}
