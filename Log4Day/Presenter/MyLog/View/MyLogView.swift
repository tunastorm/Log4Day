//
//  PhotoLogView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI
import RealmSwift
import BottomSheet

struct MyLogView: View {
    
    @ObservedObject var categoryViewModel: CategoryViewModel
    @StateObject private var viewModel = MyLogViewModel()
    
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
                        LazyVStack(pinnedViews: [.sectionHeaders]) {
                            Section(header: TitleView()) {
                                Rectangle()
                                    .fill(ColorManager.shared.ciColor.subContentColor)
                                    .frame(height: 1)
                                    .frame(maxWidth: .infinity)
                                    .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 20))
                                photoLogBanner(width: proxy.size.width)
                            }
                            if viewModel.output.logList.isEmpty {
                                HStack {
                                    Spacer()
                                    Text("오늘의 추억을 남기러 가기")
                                        .font(.title3)
                                        .foregroundStyle(ColorManager.shared.ciColor.highlightColor)
                                    Spacer()
                                }
                                .padding(.vertical, 40)
                            } else {
                                TapBarView(categoryViewModel: categoryViewModel)
                                    .environmentObject(viewModel)
                            }
                        }
                        .padding(.bottom, 130)
                    }
                    .frame(width: viewModel.output.screenWidth)
                }
                SideBarView(controller: .myLog, viewModel: categoryViewModel)
                    .environmentObject(viewModel)
            }
        }
        .onAppear {
            print(Realm.Configuration.defaultConfiguration.fileURL)
            viewModel.action(.fetchFirstLastDate)
            viewModel.action(.fetchLogDate(isInitial: true))
        }
        .bottomSheet(bottomSheetPosition: $viewModel.output.showSelectLogSheet, switchablePositions: [.dynamic]) {
            ScrollView {
                ForEach(viewModel.output.ofLogList.indices, id: \.self) { index in
                    NavigationLink {
                        NextViewWrapper(LogDetailView(log: viewModel.output.ofLogList[index], categoryViewModel: categoryViewModel))
                    } label: {
                        TimelineCell(index: index, log: viewModel.output.ofLogList[index])
                            .environmentObject(viewModel)
                    }
                    .padding(.horizontal)
                }
            }
            .frame(height: 300)
            .frame(maxWidth: .infinity)
            .background(.white)
        }
        .enableSwipeToDismiss()
    }
    
    private func TitleView() -> some View {
        VStack() {
            HStack {
                Text("Subject: ")
                    .font(.footnote)
                    .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
                Text(categoryViewModel.output.category)
                    .font(.title3)
                    .foregroundStyle(ColorManager.shared.ciColor.contentColor)
                Spacer()
                Text("Date: ")
                    .font(.footnote)
                    .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
                Text(viewModel.output.logDate)
                    .font(.footnote)
                    .foregroundStyle(ColorManager.shared.ciColor.contentColor)
            }
            .padding(.init(top: 10, leading: 20, bottom: 6, trailing: 20))
        }
        .background(ColorManager.shared.ciColor.backgroundColor)
    }
    
    private func photoLogBanner(width: CGFloat) -> some View {
        let bannerWidth = width-75
        let bannerHeight: CGFloat = 500
        let fourCutLogList = viewModel.output.logList.where{ $0.fourCut.count == 4 }
        return VStack {
            InfinityCarouselView(data: fourCutLogList, edgeSpacing: 20, contentSpacing: 20, totalSpacing: 20, contentHeight: 500, currentOffset: -(bannerWidth+15),
                carouselContent: { data, index, currentIndex, lastCell in
                FourCutPictureView(currentIndex: currentIndex, 
                                   index: index,
                                   lastCell: lastCell,
                                   title: data.title,
                                   photos: Array( data.fourCut),
                                   hashTags: "#\(data.places.map { $0.hashtag }.joined(separator: " #"))",
                                   backgroundWidthHeight: (bannerWidth,  bannerHeight), 
                                   imageHeight: 400)
                },
                zeroContent: { index, currentIndex, lastCell in
                    let title = fourCutLogList.last?.title ?? "오늘의 추억을 네 컷으로 남겨보세요"
                    let hashTags = "#\(fourCutLogList.last?.places.map { $0.hashtag }.joined(separator: " #") ?? "네컷으로 남기는 오늘, Log4Day")"
                    FourCutPictureView(currentIndex: currentIndex,
                                       index: index,
                                       lastCell: lastCell,
                                       title: title,
                                       photos: Array(fourCutLogList.last?.fourCut ?? List<Photo>()),
                                       hashTags: hashTags,
                                       backgroundWidthHeight: (bannerWidth, bannerHeight),
                                       imageHeight: bannerHeight-100)
                },
                overContent: { index, currentIndex, lastCell in
                    let title = fourCutLogList.first?.title ?? ""
                    let hashTags = "#\(fourCutLogList.first?.places.map { $0.hashtag }.joined(separator: " #") ?? "")"
                    FourCutPictureView(currentIndex: currentIndex,
                                       index: index,
                                       lastCell: lastCell,
                                       title: title,
                                       photos: Array(fourCutLogList.first?.fourCut ?? List<Photo>()),
                                       hashTags: hashTags,
                                       backgroundWidthHeight: (bannerWidth, bannerHeight),
                                       imageHeight: bannerHeight-100)
                }
            )
            .frame(height: bannerHeight)
            .padding(.top, 10)
            .hideIndicator()
            .environmentObject(viewModel)
            ListFooterView(text: viewModel.output.firstLastDate.0, font: .footnote)
                .padding()
        }
    }
    
}

