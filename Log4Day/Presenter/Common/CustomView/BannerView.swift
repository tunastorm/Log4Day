//
//  BannerView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

struct BannerView: View {

    var title: String
    
    var hashTags: String
    
    var backgroundWidthHeight: (CGFloat, CGFloat)
    
    var imageHeight: CGFloat
    
    var body: some View {
        ZStack {
            backgroundView()
            contentsView()
        }
    }
    
    private func backgroundView() -> some View {
        Rectangle()
//        RoundedRectangle(cornerRadius: 25)
            .fill(.white)
            .frame(width: backgroundWidthHeight.0, height: backgroundWidthHeight.1)
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
        VStack {
            HStack {
                Image(systemName: "person")
                    .frame(width: ((backgroundWidthHeight.0 - 10) / 2)-10,height: (imageHeight / 2) - 10)
                    .background(.gray)
//                    .cornerRadius(15, corners: [.topLeft])
                Image(systemName: "person")
                    .frame(width: ((backgroundWidthHeight.0 - 10) / 2)-10,height: (imageHeight / 2) - 10)
                    .background(.gray)
//                    .cornerRadius(15, corners: [.topRight])
            }
            HStack {
                Image(systemName: "person")
                    .frame(width: ((backgroundWidthHeight.0 - 10) / 2)-10,height: (imageHeight / 2) - 10)
                    .background(.gray)
//                    .cornerRadius(15, corners: [.bottomLeft])
                Image(systemName: "person")
                    .frame(width: ((backgroundWidthHeight.0 - 10) / 2)-10,height: (imageHeight / 2) - 10)
                    .background(.gray)
//                    .cornerRadius(15, corners: [.bottomRight])
            }
        }
        
    }
    
}
