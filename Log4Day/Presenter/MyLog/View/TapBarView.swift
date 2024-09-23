//
//  ScheduleListView.swift
//  Log4Day
//
//  Created by 유철원 on 9/20/24.
//

import SwiftUI

enum TapInfo : String, CaseIterable {
    case timeline = "타임라인"
    case place = "플레이스"
    case waited = "사진없음"
}

struct TapBarView: View {
    
    @EnvironmentObject var viewModel: CategoryViewModel
    @State private var selectedPicker: TapInfo = .timeline
    @Namespace private var animation

    var body: some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            Section(header: TopTabbar(selectedPicker: $selectedPicker, animation: animation)) {
                LazyVStack {
                    switch selectedPicker {
                    case .timeline: timelineList()
                    case .place: placeList()
                    case .waited: waitedList()
                    }
                }
                .background(.clear)
                .frame(maxWidth: .infinity)
                .padding()
            }
        }
        .onAppear {
            viewModel.action(.tapBarChanged(info: selectedPicker))
        }
    }

    private func timelineList() -> some View {
        ForEach(viewModel.output.timeline.indices, id: \.self) { index in
            NavigationLink {
                NextViewWrapper(LogDetail())
            } label: {
                TimelineCell(index: index, log: viewModel.output.timeline[index])
                    .environmentObject(viewModel)
            }
        }
    }
    
    private func placeList() -> some View {
        ForEach(viewModel.output.placeList.indices, id: \.self) { index in
            
        }
    }
    
    
    private func waitedList() -> some View {
        ForEach(viewModel.output.nonPhotoLogList.indices, id: \.self) { index in
            
        }
    }

}

struct TopTabbar: View {
    
    @Binding var selectedPicker: TapInfo
    var animation: Namespace.ID
    
    var body: some View {
        ZStack(alignment: .bottom) {
            HStack {
                ForEach(TapInfo.allCases, id: \.self) { item in
                    VStack {
                        Text(item.rawValue)
                            .font(.headline)
                            .frame(maxWidth: .infinity/4, minHeight: 30)
                            .foregroundColor(selectedPicker == item ?
                                .mint: .gray)
                            .padding(.horizontal)
                        if selectedPicker == item {
                            Capsule()
                                .foregroundColor(Resource.ciColor.highlightColor)
                                .frame(height: 3)
                                .matchedGeometryEffect(id: "info", in: animation)
                                .padding(.horizontal)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            selectedPicker = item
                        }
                    }
                }
            }
        }
        .background(Resource.ciColor.backgroundColor)
    }
}


#Preview {
    TapBarView()
}
