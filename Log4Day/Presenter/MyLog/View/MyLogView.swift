//
//  PhotoLogView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI
import RealmSwift

struct TestSchedule: Hashable, Identifiable {
    
    let id = UUID()
    var title: String
    var hashTags: String
    
}


struct MyLogView: View {
    
    @StateObject private var viewModel = MyLogViewModel()
    @StateObject private var categoryViewModel = CategoryViewModel()
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack {
                    NavigationBar(title: "MyLog", button:
                        Button(action: {
                            withAnimation(.spring()){
                                categoryViewModel.action(.sideBarButtonTapped)
                            }
                        }, label: {
                            Image(systemName: "tray")
                                .font(.system(size: 20))
                        })
                    )
                    ScrollView {
                        LazyVStack {
                            TitleView()
                            photoLogBanner(width: proxy.size.width)
                            Spacer()
                            LoglineView()
                        }
                        .padding(.bottom, 130)
                    }
                    .frame(width: viewModel.output.screenWidth)
                }
                SideBarView()
                    .environmentObject(categoryViewModel)
            }
        }
        .onAppear {
            print(Realm.Configuration.defaultConfiguration.fileURL)
        }
    }
    
    private func TitleView() -> some View {
        VStack() {
            HStack {
                Text("Subject: ")
                    .font(.caption)
                    .foregroundStyle(Resource.ciColor.subContentColor)
                Text(categoryViewModel.output.category)
                    .font(.title3)
                    .foregroundStyle(Resource.ciColor.contentColor)
                Spacer()
                Text("Date: ")
                    .font(.caption)
                    .foregroundStyle(Resource.ciColor.subContentColor)
                Text("2024.09.22/일")
                    .font(.title3)
                    .foregroundStyle(Resource.ciColor.subContentColor)
            }
            .padding(.init(top: 10, leading: 20, bottom: 2, trailing: 20))
            Rectangle()
                .fill(Resource.ciColor.subContentColor)
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .padding(.init(top: 2, leading: 20, bottom: 20, trailing: 20))
        }
    }
    
    private func photoLogBanner(width: CGFloat) -> some View {
        let bannerWidth = width-75
        let bannerHeight: CGFloat = 500
        return VStack {
            InfinityCarouselView(data: categoryViewModel.output.logList, edgeSpacing: 20, contentSpacing: 20, totalSpacing: 20, contentHeight: 500, currentOffset: -(bannerWidth+15),
                carouselContent: { data, index, currentIndex, lastCell in
                FourCutPictureView(currentIndex: currentIndex, index: index, lastCell: lastCell, title: data.title, hashTags: "#\(data.places.map { $0.hashtag }.joined(separator: " #"))", 
                                   backgroundWidthHeight: (bannerWidth,  bannerHeight), imageHeight: 400)
                },
                zeroContent: { index, currentIndex, lastCell in
                    let title = categoryViewModel.output.logList.last?.title ?? "오늘의 추억을 네 컷으로 남겨보세요"
                    let hashTags = "#\(categoryViewModel.output.logList.last?.places.map { $0.hashtag }.joined(separator: " #") ?? "소중한 #오늘의 #기록")"
                    FourCutPictureView(currentIndex: currentIndex, index: index, lastCell: lastCell, title: title, hashTags: hashTags, backgroundWidthHeight: (bannerWidth, bannerHeight), imageHeight: bannerHeight-100)
                }, 
                overContent: { index, currentIndex, lastCell in
                    let title = categoryViewModel.output.logList.first?.title ?? ""
                    let hashTags = "#\(categoryViewModel.output.logList.first?.places.map { $0.hashtag }.joined(separator: " #") ?? "")"
                    FourCutPictureView(currentIndex: currentIndex, index: index, lastCell: lastCell, title: title, hashTags: hashTags, backgroundWidthHeight: (bannerWidth, bannerHeight), imageHeight: bannerHeight-100)
                }
            )
            .frame(height:  bannerHeight)
            .hideIndicator()
            ListFooterView(text: "24.01.01", font: .title3)
                .padding(.horizontal)
                .padding(.top)
        }
    }
    
}

#Preview {
    MyLogView()
}
