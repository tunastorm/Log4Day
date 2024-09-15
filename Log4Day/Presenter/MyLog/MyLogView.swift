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
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var baseColor: Color {
        colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5)
    }
    
    private var contentColor: Color {
        colorScheme == .dark ? .white : .black
    }

    private static let setDummies = {
        let random = Int.random(in: 5...10)
        print("dummyCount:", random)
        return (0..<random).map { index in
            TestSchedule(title: "테스트 \(index)", hashTags: "#테스트 일정 \(index) #입니다만?")
        }
    }
    
    @State private var dummy: [TestSchedule] = Self.setDummies()
    
    var body: some View {
        GeometryReader { proxy in
            print("screenSize:", proxy.size)
            return ScrollView {
                VStack {
                    TitleView()
                    photoLogBanner(width: proxy.size.width)
                    Spacer()
                    loglineList()
                }
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
        VStack() {
            HStack {
                Text("Subject: ")
                    .font(.caption)
                    .foregroundStyle(baseColor)
                Text("카테고리")
                    .font(.title3)
                    .foregroundStyle(contentColor)
                Spacer()
                Text("Date: ")
                    .font(.caption)
                    .foregroundStyle(baseColor)
                Text("24.09.13 / 금")
                    .font(.title3)
                    .foregroundStyle(contentColor)
            }
            .padding(.init(top: 10, leading: 20, bottom: 2, trailing: 20))
            Rectangle()
                .fill(baseColor)
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .padding(.init(top: 2, leading: 20, bottom: 20, trailing: 20))
        }
    }
    
    private func photoLogBanner(width: CGFloat) -> some View {
        let bannerWidth = width-75
        let bannerHeight: CGFloat = 500
        return InfinityCarouselView(data: dummy, edgeSpacing: 20, contentSpacing: 20, totalSpacing: 20, contentHeight: 500, currentOffset: -(bannerWidth+15), carouselContent: { data, index, currentIndex, lastCell in
            FourCutPictureView(currentIndex: currentIndex, index: index, lastCell: lastCell, title: data.title, hashTags: data.hashTags, backgroundWidthHeight: (bannerWidth,  bannerHeight), imageHeight: 400)
            }, zeroContent: { index, currentIndex, lastCell in
                let title = dummy.last?.title ?? ""
                let hashTags = dummy.last?.hashTags ?? ""
                FourCutPictureView(currentIndex: currentIndex, index: index, lastCell: lastCell, title: title, hashTags: hashTags, backgroundWidthHeight: (bannerWidth, bannerHeight), imageHeight: bannerHeight-100)
            }, overContent: { index, currentIndex, lastCell in
                FourCutPictureView(currentIndex: currentIndex, index: index, lastCell: lastCell, title: dummy[0].title, hashTags: dummy[0].hashTags, backgroundWidthHeight: (bannerWidth, bannerHeight), imageHeight: bannerHeight-100)
            }
        )
        .frame(height:  bannerHeight)
        .hideIndicator()
    }
    
    private func loglineList() -> some View {
        LazyVStack {
            ListHeaderView(text: "24.01.01", font: .title3)
            Rectangle()
                .fill(baseColor)
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .padding(.bottom)
            ForEach(0..<100) { index in
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
