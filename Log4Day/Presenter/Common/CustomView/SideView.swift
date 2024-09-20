//
//  SideView.swift
//  Log4Day
//
//  Created by 유철원 on 9/15/24.
//

import SwiftUI

struct SideView: View {

    @Binding var isShow: Bool
     
    @Namespace var namespace
    
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var selectedTitle: String
    
    @Binding var categoryList: [String]
    
    private var baseColor: Color {
        colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.25)
    }
    
    private var normalColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.white
//                .shadow(radius:4, x: 4, y: 8)
            VStack {
                HStack {
                    Text("Subject: ")
                        .font(.caption)
                        .foregroundStyle(baseColor)
                    Text("카테고리")
                        .font(.headline)
                        .foregroundColor(Resource.CIColor.highlightColor)
                    Spacer()
                    Button {
                        withAnimation {
                            isShow = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .padding(.trailing)
                    .foregroundStyle(normalColor)
                }
                .padding(.leading)
                .padding(.top)
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(baseColor)
                Spacer()
                ScrollView {
                    ForEach(categoryList, id: \.self) { item in
                        HStack {
                            SidebarButton(selectedTitle: $selectedTitle, title: item, namespace: namespace)
                        }
                    }
                }
                Spacer()
            }
        }
        .frame(width: 240)
        .offset(x: isShow ? 0 : -248)
    }
    
}
