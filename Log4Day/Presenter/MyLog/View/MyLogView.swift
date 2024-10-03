//
//  PhotoLogView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI
import RealmSwift
import BottomSheet
import Photos

struct MyLogView: View {
    
    @Binding var tapSelection: Int
    
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
                                    Button {
                                        tapSelection = 1
                                    } label: {
                                        Text("추억을 기록하러 가기")
                                            .font(.title3)
                                            .multilineTextAlignment(.center)
                                            .foregroundStyle(ColorManager.shared.ciColor.highlightColor)
                                    }
                                    Spacer()
                                }
                                .padding(.vertical, 40)
                            } else {
                                TapBarView(categoryViewModel: categoryViewModel)
                                    .environmentObject(viewModel)
                            }
                        }
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
        .bottomSheet(bottomSheetPosition: $viewModel.output.showSaveFourCutSheet, switchablePositions: [.dynamic], content: {
            VStack(alignment: .center) {
                Button{
                    let authorizationStatus = PHPhotoLibrary.authorizationStatus()
                    switch authorizationStatus {
                            case .authorized: // 사용자가 앱에 사진 라이브러리에 대한 액세스 권한을 명시 적으로 부여했습니다.
                                UIImageWriteToSavedPhotosAlbum(viewModel.output.fourCutImage, nil, nil, nil)
                            case .denied: break // 사용자가 사진 라이브러리에 대한 앱 액세스를 명시 적으로 거부했습니다.
                            case .limited: break // ?
                            case .notDetermined: // 사진 라이브러리 액세스에는 명시적인 사용자 권한이 필요하지만 사용자가 아직 이러한 권한을 부여하거나 거부하지 않았습니다
                                PHPhotoLibrary.requestAuthorization { (state) in
                                    if state == .authorized {
                                        UIImageWriteToSavedPhotosAlbum(viewModel.output.fourCutImage, nil, nil, nil)
                                    }
                                }
                            case .restricted: break // 앱이 사진 라이브러리에 액세스 할 수있는 권한이 없으며 사용자는 이러한 권한을 부여 할 수 없습니다.
                            default: break
                    }
                    viewModel.output.showSaveFourCutSheet = .hidden
                } label: {
                    Text("갤러리에 저장하기")
                        .frame(width: 160, height: 40)
                        .background(ColorManager.shared.ciColor.highlightColor)
                        .cornerRadius(20, corners: .allCorners)
                        .foregroundStyle(.white)
                }
                .padding(.top, 100)
                Spacer()
            }
            .frame(height: 300)
            .frame(maxWidth: .infinity)
            .background(.white)
        })
        .enableSwipeToDismiss()
        .bottomSheet(bottomSheetPosition: $viewModel.output.showSelectLogSheet, switchablePositions: [.dynamic]) {
            ScrollView {
                ForEach(viewModel.output.ofLogList.indices, id: \.self) { index in
                    NavigationLink {
                        NextViewWrapper(LogDetailView(logId: viewModel.output.ofLogList[index].id, categoryViewModel: categoryViewModel, myLogViewModel: viewModel))
                    } label: {
                        let log = viewModel.output.ofLogList[index]
                        return TimelineCell(index: index,
                                            title: log.title,
                                            startDate: log.startDate,
                                            fourCutCount: log.fourCut.count)
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
        let fourCutLogList = viewModel.output.logList
                            .where({ $0.fourCut.count == 4 })
                            .sorted(byKeyPath: Log.Column.startDate.name, ascending: false)
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
                    let hashTags = "#\(fourCutLogList.last?.places.map { $0.hashtag }.joined(separator: " #") ?? "네컷일기, Log4Day")"
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

