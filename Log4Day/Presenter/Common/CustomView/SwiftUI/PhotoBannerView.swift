//
//  PhotoBannerView.swift
//  Log4Day
//
//  Created by 유철원 on 9/19/24.
//

import SwiftUI

struct PhotoBannerView: View {
    
    @StateObject private var viewModel = PhotoBannerViewModel()
    
    var body: some View {
//        print("listCount: ", viewModel.FourCutPhotoList.count)
        InfinitePageView(
            selection: $viewModel.FourCutPhotoIndex,
            before: { viewModel.correctedIndex(for: $0 - 1) },
            after: { viewModel.correctedIndex(for: $0 + 1) },
            view: { index in
                ZStack {
                    PhotoBannerItemView(pageIndex: $viewModel.FourCutPhotoIndex, pageTotal: .constant(viewModel.FourCutPhotoList.count))
                }
                withAnimation {
                    Image("person").resizable()
                }
            }
        )
        .frame(width: 200,height: 500)
        .background(.red)
        .onAppear {
            viewModel.startAutoScroll()
        }
        onDisappear {
            viewModel.stopAutoScroll()
        }
    }
}
