//
//  WriteLogView.swift
//  Log4Day
//
//  Created by 유철원 on 9/23/24.
//

import SwiftUI
import NMapsMap

struct NewLogView: View {
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
                timelineList()
            }
        }
    }

    private func titleView() -> some View {
        VStack() {
            HStack {
                VStack(alignment: .leading) {
                    TextField("", text: $viewModel.input.title)
                        .font(.title3)
//                        .bold()
                    Text("2024.09.01 / 일")
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
                .padding(.leading)
                .padding(.vertical)
                Spacer()
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<4) { index in
                        HashTagCell(hashTag: "#태그\(index)")
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func timelineList() -> some View {
        LazyVStack {
            ForEach(0..<100) { index in
//                TimelineCell(index: index)
            }
        }
        .background(.clear)
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#Preview {
    NewLogView()
}
