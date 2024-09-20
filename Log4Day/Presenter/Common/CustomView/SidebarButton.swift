//
//  SideBarButton.swift
//  Log4Day
//
//  Created by 유철원 on 9/15/24.
//

import SwiftUI

struct SidebarButton: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var selectedTitle: String
    
    var title: String
    var namespace: Namespace.ID
    
    private var baseColor: Color {
        colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.25)
    }

    var body: some View {
        Button(action: {
            //선택된 타이틀은 selectedTab 값이 된다
            //namespace 애니메이션을 넣기 위해서 애니메이션이 있어야한다.
            withAnimation(.spring()) {
                selectedTitle = title
            }
        }) {
            HStack(spacing: 20){
                Spacer()
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundStyle(selectedTitle == title ? Resource.CIColor.highlightColor  :  baseColor)
                    .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 60))
            }
        }
        .frame(height: 40)
        .frame(maxWidth: .infinity)
        .background(
            HStack {
                VStack{
                    Spacer()
                    ZStack(alignment: .bottom) {
                        if selectedTitle == title {
                            Resource.CIColor.highlightColor
                            //                    Color(hue: 0.5, saturation: 0.6, brightness: 0.046)
                            // 선택된 뷰에 배경
                                .opacity(selectedTitle == title ? 1 : 0)
                            // CustomCorners
                            //                    .clipShape(RoundedCorner(radius: 12, corners: [.topRight, .bottomRight]))
                            // id별 궤적 생성 애니메이션
                                .matchedGeometryEffect(id: "TapEffect", in: namespace)
                            
                        } else {
                            baseColor
                        }
                    }
                    .frame(height: 1)
                }
                .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 50))
            }
        )
    }
}


