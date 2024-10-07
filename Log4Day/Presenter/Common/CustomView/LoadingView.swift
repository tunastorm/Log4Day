//
//  LoadingView.swift
//  Log4Day
//
//  Created by 유철원 on 10/7/24.
//

import SwiftUI

struct LoadingView: View {
    
    @Binding var loadingState: Bool
    
    var body: some View {
        ZStack {
            // 로딩 바를 나타낼 배경
//            Color.gray.opacity(0.3)
//                .ignoresSafeArea()
//                .opacity(loadingState ? 1 : 0) // 로딩 중에만 보이도록 설정
            // 로딩 바
            ZStack {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle()) // 로딩 바 스타일 설정
                        .scaleEffect(2) // 크기 조절
                        .padding(.top, 60)
                        .opacity(loadingState ? 1 : 0) // 로딩 중에만 보이도록 설정

                    // 로딩 중 메시지
                    Text("사진 추가 중")
                        .font(.footnote)
                        .bold()
                        .foregroundColor(ColorManager.shared.ciColor.highlightColor)
                        .padding(.top, 10)
                        .opacity(loadingState ? 1 : 0) // 로딩 중에만 보이도록 설정
                }
            }
            
        }
    }
    
}

