//
//  ScheduleListView.swift
//  Log4Day
//
//  Created by 유철원 on 9/20/24.
//

import SwiftUI

enum tapInfo : String, CaseIterable {
    case schedule = "일정"
    case memory = "로그라인"
    case forgotten = "대기"
}

struct LoglineView: View {

    @State private var selectedPicker: tapInfo = .schedule
    @Namespace private var animation
    
//    private var baseColor: Color {
//        colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5)
//    }

    var body: some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            Section(header: TopTabbar(selectedPicker: $selectedPicker, animation: animation)) {
                loglineList()
            }
        }
    }
    
    private func loglineList() -> some View {
        LazyVStack {
            ForEach(0..<100) { index in
                LoglineCell(index: index)
            }
        }
        .background(.clear)
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    
}

struct TopTabbar: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var selectedPicker: tapInfo
    var animation: Namespace.ID
    
    private var headerBackgroundColor: Color {
        colorScheme == .dark ? .black : .white
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
//            Rectangle()
//                .fill(.black.opacity(0.5))
//                .frame(height: 1)
//                .frame(maxWidth: .infinity)
//                .padding(.horizontal)
//                .padding(.bottom)
            HStack {
                ForEach(tapInfo.allCases, id: \.self) { item in
                    VStack {
                        Text(item.rawValue)
                            .font(.headline)
                            .frame(maxWidth: .infinity/4, minHeight: 30)
                            .foregroundColor(selectedPicker == item ?
                                .mint: .gray)
                            .padding(.horizontal)
                        if selectedPicker == item {
                            Capsule()
                                .foregroundColor(Resource.CIColor.highlightColor)
                                .frame(height: 3)
                                .matchedGeometryEffect(id: "info", in: animation)
                                .padding(.horizontal)
                        }
                    }
//                    .padding(.bottom)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            selectedPicker = item
                        }
                    }
                }
            }
        }
        .background(headerBackgroundColor)
    }
}


#Preview {
    LoglineView()
}
