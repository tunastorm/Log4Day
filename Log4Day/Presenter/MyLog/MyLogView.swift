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
    
    @State private var selectedTitle = "전체"
    //사이드뷰 버튼용 변수
    @State private var showSide = false
    //Sliding을 위한 변수
    @State private var translation: CGSize = .zero
    @State private var offsetX: CGFloat = -120
    
    @State private var categoryList = [
        "전체", "데이트", "회사", "고등학교 친구", "중학교 친구", "러닝크루"
    ]
    
    @State private var dummy: [TestSchedule] = (0..<Int.random(in: 5...100)).map { index in
        TestSchedule(title: "테스트 \(index)", hashTags: "#테스트 일정 \(index) #입니다만?")
    }
    
    private var screenWidth = UIScreen.main.bounds.width
    
    private var normalColor: Color {
        colorScheme == .dark ? .white.opacity(0.75) : .black
    }
    
    private var baseColor: Color {
        colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5)
    }
    
    private var contentColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack {
                    HStack {
                        Text("MyLog")
                            .frame(width: 80, height: 40)
                            .font(.headline)
                            .foregroundStyle(Resource.CIColor.highlightColor)
                            .padding(.leading)
                        Spacer()
                        Button(action: {
                            withAnimation(.spring()){
                               showSide.toggle()
                            }
                        }, label: {
                            Image(systemName: "tray")
                        })
                        .foregroundStyle(.black)
                        .buttonStyle(IsPressedButtonStyle(normalColor: normalColor, pressedColor: .gray))
                        SettingButton()
                        .padding(.trailing)
                    }
                    .frame(width: screenWidth)
                    ScrollView {
                        VStack {
                            TitleView()
//                            PhotoBannerView()
                            photoLogBanner(width: proxy.size.width)
                            Spacer()
                            loglineList()
                        }
                    }
                    .frame(width: screenWidth)
                }
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.black)
                    .opacity(showSide ? 0.7 : 0)
                HStack {
                    SideView(isShow: $showSide, selectedTitle: $selectedTitle, categoryList: $categoryList)
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.clear)
                }
                .frame(height: UIScreen.main.bounds.height)
//                .frame(maxHeight: .infinity)
//                //홈과 사이드 메뉴가 움직이도록 하는 오프셋
//                .offset(x: (translation.width + offsetX) > -120 ?
//                        ((translation.width + offsetX) < 120 ? translation.width + offsetX : 0) : -2)
//                //사이드메뉴 버튼으로 showSide값에 변화가 있을 때, 사이드 메뉴 열기
//                .onChange(of: showSide) {_ in
//                    withAnimation(.spring()) {
//                        print("showSide:", showSide)
//                        print("offsetX:", offsetX)
//                        if showSide {
//                            offsetX = 120
//                        }
//                        if !showSide && offsetX == 120 {
//                            offsetX = -120
//                            print("showSide OFF")
//                        }
//                    }
//                }
            }
//            .toolbar {
//                ToolbarTitle(text: "MyLog", placement: .topBarLeading)
//                ToolbarButton(id: "category", placement: .topBarTrailing, image: "tray") {
//                    withAnimation(.spring()){
//                       showSide.toggle()
//                    }
//                }
//                SettingButton()
//            }
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
