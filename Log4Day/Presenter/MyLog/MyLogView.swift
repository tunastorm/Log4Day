//
//  PhotoLogView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

struct TestSchedule: Hashable, Identifiable {
    
    let id = UUID()
    var title: String
    var hashTags: String
    
}


struct MyLogView: View {
    
    private static let setDummies = {
        let random = Int.random(in: 5...10)
        print("dummyCount:", random)
        return (0..<random).map { index in
            TestSchedule(title: "테스트 \(index)", hashTags: "#테스트 일정 \(index) #입니다만?")
        }
    }
    
    @State private var dummy: [TestSchedule] = Self.setDummies()
    
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
            SettingButton()
        }
        .onAppear {
           
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
        InfinityCarouselView(data: dummy, edgeSpacing: 20, contentSpacing: 20, totalSpacing: 0, contentHeight: 500, carouselContent: { data  in
            BannerView(title: data.title, hashTags: data.hashTags, backgroundWidthHeight: (300, 500), imageHeight: 400)
            }, zeroContent: {
                let title = dummy.last?.title ?? ""
                let hashTags = dummy.last?.hashTags ?? ""
                BannerView(title: title, hashTags: hashTags, backgroundWidthHeight: (300,500), imageHeight: 400)
            }, overContent: {
                BannerView(title: dummy[0].title, hashTags: dummy[0].hashTags, backgroundWidthHeight: (300,500), imageHeight: 400)
            }
        )
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
