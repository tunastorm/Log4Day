//
//  SwiftUIView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

struct NavigationWrapper<Content: View>: View {
    
    let content: Content
    
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                content
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton())
            .background(.white)
            .tint(.mint)
        } else {
            NavigationView {
                content
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton())
            .background(.white)
            .tint(.mint)
        }
    }
    
    private func backButton() -> some View {
        BackButton()
//        Button {
//            self.presentationMode.wrappedValue.dismiss()
//        } label: {
//            HStack {
//                Image(systemName: "chevron.left")
//                    .aspectRatio(contentMode: .fit)
//            }
//        }
//        .foregroundStyle(.black)
    }
    
}
