//
//  BannerView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI
import SwiftUIX

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
        VisualEffectBlurView(blurStyle: .systemChromeMaterial, vibrancyStyle: .fill) {
           
        }
        .frame(width: backgroundWidthHeight.0 , height: backgroundWidthHeight.1)
        .overlay(RoundedRectangle(cornerRadius: 0, style: .continuous).stroke(lineWidth: 1).fill(Color.white))
        .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 4)
        .padding()
        .blendMode(.luminosity)
//        return Rectangle()
//            .fill(.white)
//            .frame(width: backgroundWidthHeight.0, height: backgroundWidthHeight.1)
        
//            .frame(width: backgroundWidthHeight.0, height: (index == currentIndex || (isFirstToLast || isLastToFirst)) ? backgroundWidthHeight.1 : backgroundWidthHeight.1 * 0.7)
    }
    
    private func contentsView() -> some View {
        VStack {
            ImageGrid()
            Text(title)
                .frame(height: 30)
                .frame(alignment: .leading)
                .foregroundStyle(ColorManager.shared.ciColor.contentColor)
            Text(hashTags)
                .frame(height: 30)
                .frame(alignment: .leading)
                .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
        }
        .padding()
    }
    
    private func ImageGrid() -> some View {
//        let isLastToFirst = index == 1 && currentIndex == lastCell + 1
//        let isFirstToLast = index == lastCell && currentIndex == 0
//        let height = (index == currentIndex || (isFirstToLast || isLastToFirst)) ? imageHeight : imageHeight * 0.7
//        let topPadding: CGFloat = (index == currentIndex || (isFirstToLast || isLastToFirst)) ? 10 : 25
        
        let topPadding: CGFloat = 10
        let height = (imageHeight / 2) - topPadding
        let width = ((backgroundWidthHeight.0 - 10) / 2)-10
        return VStack {
            HStack {
                Image("default4Cut4")
                    .resizable()
                    .frame(width: width, height: height)
                    .background(ColorManager.shared.ciColor.subContentColor)
//                    .relativeSize(width: width, height: height)
                Image("default4Cut2")
                    .resizable()
                    .frame(width: width, height: height)
                    .background(ColorManager.shared.ciColor.subContentColor)
//                    .relativeSize(width: width, height: height)
            }
            HStack {
                Image("default4Cut3")
                    .resizable()
                    .frame(width: width, height: height)
                    .background(ColorManager.shared.ciColor.subContentColor)
//                    .relativeSize(width: width, height: height)
                Image("default4Cut5")
                    .resizable()
                    .frame(width: width, height: height)
                    .background(ColorManager.shared.ciColor.subContentColor)
//                    .relativeSize(width: width, height: height)
                
            }
        }
        
    }
    
}
