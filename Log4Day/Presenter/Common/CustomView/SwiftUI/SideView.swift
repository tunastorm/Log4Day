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
    
    @State var deleteAlert: Bool = false
    
    @State var addAlert: Bool = false
    
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
                titleView()
                Spacer()
                categoryListView()
            }
        }
        .frame(width: 240)
        .frame(maxHeight: .infinity)
        .offset(x: isShow ? 0 : -248)
    }
    
    private func titleView() -> some View {
        VStack {
            HStack {
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
        }
    }
    
    private func categoryListView() -> some View {
        ScrollView {
            ForEach(categoryList, id: \.self) { item in
                HStack {
                    SidebarButton(selectedTitle: $selectedTitle, title: item, namespace: namespace)
                }
            }
        }
        .padding(.init(top: 0, leading: 0, bottom: 140, trailing: 0))
    }
    
    private func buttonView() -> some View {
        HStack {
            Button {
                deleteAlert.toggle()
            } label: {
                Text("삭제하기")
            }
            .padding(.horizontal)
            .alert(LocalizedStringKey("삭제"), isPresented: $deleteAlert) {
                Text("삭제")
                Text("취소")
            }
            Rectangle()
                .frame(width: 1)
                .frame(maxHeight: .infinity)
                .padding(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                .foregroundStyle(baseColor)
            Button {
                addAlert.toggle()
            } label: {
                Text("추가하기")
            }
            .padding(.horizontal)
            .alert(LocalizedStringKey("추가"), isPresented: $addAlert) {
                Text("추가")
                Text("취소")
            }
          
        }
        .frame(height: 40)
        .frame(maxWidth: .infinity)
    }
    
}
