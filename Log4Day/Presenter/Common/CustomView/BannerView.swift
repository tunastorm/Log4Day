//
//  BannerView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

struct BannerView: View {
    
    var index: Int
    
    var backgroundWidthHeight: (CGFloat, CGFloat)
    
    var imageHeight: CGFloat
    
    var body: some View {
        ZStack {
            backgroundView()
            contentsView()
        }
    }
    
    private func backgroundView() -> some View {
        RoundedRectangle(cornerRadius: 25)
            .stroke(lineWidth: 1)
            .frame(width: backgroundWidthHeight.0, height: backgroundWidthHeight.1)
    }
    
    private func contentsView() -> some View {
        VStack {
            Image(systemName: "person")
                .frame(height: imageHeight)
                .frame(maxWidth: .infinity)
                .background(.gray)
                .clipShape(.rect(cornerRadius: 15))
            Text("테스트 \(index)")
                .frame(height: 30)
                .frame(alignment: .leading)
            Text("#테스트 사진 \(index) #입니다만 #???")
                .frame(height: 30)
                .frame(alignment: .leading)
        }
        .padding()
    }
    
}
