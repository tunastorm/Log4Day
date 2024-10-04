//
//  BannerView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI
import SwiftUIX

struct FourCutPictureView: View {

    private let photoManager = PhotoManager.shared
    
    @Binding var currentIndex: CGFloat
    
    var index: CGFloat
    
    var lastCell: CGFloat
    
    var title: String
    
    var date: String
    
    var photos: [Photo]
    
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
        VisualEffectBlurView(blurStyle: .systemChromeMaterial, vibrancyStyle: .fill) { }
        .frame(width: backgroundWidthHeight.0 , height: backgroundWidthHeight.1)
        .overlay(RoundedRectangle(cornerRadius: 0, style: .continuous).stroke(lineWidth: 1).fill(Color.white))
        .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 4)
        .padding()
        .blendMode(.luminosity)
    }
    
    private func contentsView() -> some View {
        VStack(alignment: .center) {
            ImageGrid()
            Text(title)
                .frame(height: 30)
                .frame(alignment: .leading)
                .foregroundStyle(.black.opacity(0.8))
                .padding(.top)
            HStack {
                Spacer()
                Text(date)
                    .font(.system(size: 12))
                    .frame(height: 30)
                    .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
                    .padding(.horizontal)
            }
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
        let width = ((backgroundWidthHeight.0 - 10) / 2) - 10
        let photoCount = photos.count
        return VStack {
            if photoCount == 0 {
                HStack {
                    Image("default4Cut\(0)")
                        .resizable()
                        .frame(width: width, height: height)
                        .background(ColorManager.shared.ciColor.subContentColor)
                    Image("default4Cut\(1)")
                        .resizable()
                        .frame(width: width, height: height)
                        .background(ColorManager.shared.ciColor.subContentColor)
                }
                HStack {
                    Image("default4Cut\(2)")
                        .resizable()
                        .frame(width: width, height: height)
                        .background(ColorManager.shared.ciColor.subContentColor)
                    Image("default4Cut\(3)")
                        .resizable()
                        .frame(width: width, height: height)
                        .background(ColorManager.shared.ciColor.subContentColor)
                }
            } else {
                HStack {
                    Image(uiImage: photoManager.loadImageToDocument(filename: photos[0].name) ?? UIImage(systemName: "photo")!)
                        .resizable()
                        .frame(width: width, height: height)
                        .background(ColorManager.shared.ciColor.subContentColor)
                    Image(uiImage: photoManager.loadImageToDocument(filename: photos[1].name) ?? UIImage(systemName: "photo")!)
                        .resizable()
                        .frame(width: width, height: height)
                        .background(ColorManager.shared.ciColor.subContentColor)
                }
                HStack {
                    Image(uiImage: photoManager.loadImageToDocument(filename: photos[2].name) ?? UIImage(systemName: "photo")!)
                        .resizable()
                        .frame(width: width, height: height)
                        .background(ColorManager.shared.ciColor.subContentColor)
                    Image(uiImage: photoManager.loadImageToDocument(filename: photos[3].name) ?? UIImage(systemName: "photo")!)
                        .resizable()
                        .frame(width: width, height: height)
                        .background(ColorManager.shared.ciColor.subContentColor)
                }
            }
            
        }
        
    }
    
}
