//
//  SwiftUIView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

struct NavigationWrapper<Content: View>: View {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                content
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton(), trailing: settingButton())
            .background(.white)
            .tint(ColorManager.shared.ciColor.highlightColor)
        } else {
            NavigationView {
                content
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton(), trailing: settingButton())
            .background(.white)
            .tint((ColorManager.shared.ciColor.highlightColor))
        }
    }
    
    private func backButton() -> some View {
        BackButton()
    }
    
    private func settingButton() -> some View {
        SettingButton(inNavigationWrapper: true)
    }
    
}
