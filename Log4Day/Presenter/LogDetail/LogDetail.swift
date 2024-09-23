//
//  LogDetail.swift
//  Log4Day
//
//  Created by 유철원 on 9/20/24.
//

import SwiftUI
import NMapsMap

struct LogDetail: View {
    
    @State private var coord: (CLLocationDegrees, CLLocationDegrees) = (126.9784147, 37.5666805)
    
    var body: some View {
        NavigationWrapper {
            VStack {
                ScrollView {
                    LazyVStack {
                        titleView()
                        LogDetailMapView(coord: $coord)
                        timelineList()
                    }
                }
            }
        }
    }
    
    private func titleView() -> some View {
        VStack() {
            HStack {
                VStack(alignment: .leading) {
                    Text("2주일 만의 데이트")
                        .font(.title3)
                        .bold()
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

struct HashTagCell: View {
    
    var hashTag: String
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 15)
                .frame(height: 30)
                .frame(minWidth: 40)
                .foregroundStyle(Resource.ciColor.highlightColor)
            Text(hashTag)
                .foregroundStyle(.white)
                .font(.callout)
                .padding(.horizontal, 6)
        }
    }
    
}

#Preview {
    LogDetail()
}
