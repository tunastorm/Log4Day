//
//  PhotoLogView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

struct MyLogView: View {
    
    var body: some View {
        ScrollView {
            VStack {
                TitleView()
                photoLogBanner()
                Spacer()
                loglineList()
            }
        }
        .toolbar {
            ToolbarTitle(text: "MyLog", placement: .topBarLeading)
            ToolbarButton(id: "category", placement: .topBarTrailing, image: "tray") {
                print("카테고리 클릭")
            }
//            ToolBarNavigationLink(id: "setting",
//                                  placement: .topBarTrailing,
//                                  image: "line.3.horizontal",
//                                  view: SettingView())
            SettingButton()
        }
    }
    
    private func TitleView() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("#카테고리")
                    .font(.title)
                    .padding(.horizontal)
                    .padding(.top)
                Text("2024.09.13 / 금")
                    .padding(.horizontal)
                    .padding(.bottom)
            }
            Spacer()
        }
    }
    
    private func photoLogBanner() -> some View {
        CarouselView(pageCount: 10, visibleEdgeSpace: 10, spacing: 10) { index in
            BannerView(index: index,
                       backgroundWidthHeight: (300,500),
                       imageHeight: 400)
        }
        .frame(height: 500)
        .hideIndicator()
    }
    
    private func loglineList() -> some View {
        VStack {
            ListHeaderView(text: "Loglines", font: .title, color: .mint)
            ForEach(0..<10) { index in
                LoglineCell(index: index)
            }
        }
        .background(.clear)
        .frame(maxWidth: .infinity)
        .padding()
    }
    
}

#Preview {
    MyLogView()
}
