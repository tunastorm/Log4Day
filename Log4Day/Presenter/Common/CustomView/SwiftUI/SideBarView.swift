//
//  SideBarView.swift
//  Log4Day
//
//  Created by 유철원 on 9/20/24.
//

import SwiftUI

struct SideBarView: View {
    
    @Binding var showSide: Bool
    
    @State private var selectedTitle = "전체"
    
    @State private var categoryList = [
        "전체", "데이트", "회사", "고등학교 친구", "중학교 친구", "러닝크루", "테스트", "입니다", "람쥐", "맛도리", "유유유", "라라라", "로로로", "무무무", "123","456","789","101112","131415","161718","192021"
    ]
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .opacity(showSide ? 0.6 : 0)
                .onTapGesture {
                    withAnimation {
                        showSide = false
                    }
                }
            HStack {
                SideView(isShow: $showSide, selectedTitle: $selectedTitle, categoryList: $categoryList)
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.clear)
            }
            .frame(height: UIScreen.main.bounds.height)
        }
    }
    
    
}
