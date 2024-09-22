//
//  SideBarButton.swift
//  Log4Day
//
//  Created by 유철원 on 9/15/24.
//

import SwiftUI

struct SidebarButton: View {
    
    @EnvironmentObject private var viewModel: CategoryViewModel
    
//    @Binding var selectedTitle: String
    
    var title: String
    var namespace: Namespace.ID
    
    var body: some View {
        Button(action: {
            //선택된 타이틀은 selectedTab 값이 된다
            //namespace 애니메이션을 넣기 위해서 애니메이션이 있어야한다.
            withAnimation(.spring()) {
                viewModel.input.selectedCategory = title
                viewModel.action(.changeTapped)
                viewModel.action(.fetchFilteredList)
            }
        }) {
            HStack(spacing: 20){
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundStyle(viewModel.output.category == title ? Resource.ciColor.highlightColor : Resource.ciColor.subContentColor)
                    .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 60))
                Spacer()
            }
        }
        .frame(height: 40)
        .frame(maxWidth: .infinity)
        .background(
            HStack {
                VStack{
                    Spacer()
                    ZStack(alignment: .bottom) {
                        if viewModel.output.category == title {
                            Resource.ciColor.highlightColor
                            //                    Color(hue: 0.5, saturation: 0.6, brightness: 0.046)
                            // 선택된 뷰에 배경
                                .opacity(viewModel.output.category == title ? 1 : 0)
                            // CustomCorners
                            //                    .clipShape(RoundedCorner(radius: 12, corners: [.topRight, .bottomRight]))
                            // id별 궤적 생성 애니메이션
                                .matchedGeometryEffect(id: "TapEffect", in: namespace)
                            
                        } else {
                            Resource.ciColor.subContentColor
                        }
                    }
                    .frame(height: viewModel.output.category == title ? 1 : 0)
                }
                .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 50))
            }
        )
    }
}


