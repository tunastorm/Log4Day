//
//  BannerView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

struct FourCutPictureView: View {

    @Binding var currentIndex: CGFloat
    
    var index: CGFloat
    
    var lastCell: CGFloat
    
    var title: String
    
    var hashTags: String
    
    var backgroundWidthHeight: (CGFloat, CGFloat)
    
    var imageHeight: CGFloat
    
    var body: some View {
//        print(#function, "ForCutPictureView 렌더링")
        return ZStack {
            backgroundView()
            contentsView()
        }
        
    }
    
    private func backgroundView() -> some View {
//        let isLastToFirst = index == 1 && currentIndex == lastCell + 1
//        let isFirstToLast = index == lastCell && currentIndex == 0
        return Rectangle()
            .fill(.white)
            .frame(width: backgroundWidthHeight.0, height: backgroundWidthHeight.1)
        
//            .frame(width: backgroundWidthHeight.0, height: (index == currentIndex || (isFirstToLast || isLastToFirst)) ? backgroundWidthHeight.1 : backgroundWidthHeight.1 * 0.7)
            .shadow(radius: 4)
    }
    
    private func contentsView() -> some View {
        VStack {
            ImageGrid()
            Text(title)
                .frame(height: 30)
                .frame(alignment: .leading)
                .foregroundStyle(.black)
            Text(hashTags)
                .frame(height: 30)
                .frame(alignment: .leading)
                .foregroundStyle(.black)
        }
        .padding()
    }
    
    private func ImageGrid() -> some View {
//        let isLastToFirst = index == 1 && currentIndex == lastCell + 1
//        let isFirstToLast = index == lastCell && currentIndex == 0
//        let height = (index == currentIndex || (isFirstToLast || isLastToFirst)) ? imageHeight : imageHeight * 0.7
//        let topPadding: CGFloat = (index == currentIndex || (isFirstToLast || isLastToFirst)) ? 10 : 25
        let height = imageHeight
        let topPadding: CGFloat = 10
        return VStack {
            HStack {
                Image(systemName: "person")
                    .frame(width: ((backgroundWidthHeight.0 - 10) / 2)-10, height: (height / 2) - topPadding)
                    .background(.gray)
                Image(systemName: "person")
                    .frame(width: ((backgroundWidthHeight.0 - 10) / 2)-10,height: (height / 2) - topPadding)
                    .background(.gray)
            }
            HStack {
                Image(systemName: "person")
                    .frame(width: ((backgroundWidthHeight.0 - 10) / 2)-10, height: (height / 2) - topPadding)
                    .background(.gray)
                Image(systemName: "person")
                    .frame(width: ((backgroundWidthHeight.0 - 10) / 2)-10, height: (height / 2) - topPadding)
                    .background(.gray)
            }
        }
        
    }
    
}
