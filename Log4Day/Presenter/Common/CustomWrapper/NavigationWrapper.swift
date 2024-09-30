//
//  SwiftUIView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

struct NavigationWrapper<Button: View, Content: View>: View {
    
    var button: Button?
    let content: Content
    
    init(button: Button? = nil,  @ViewBuilder content: () -> Content) {
        self.button = button
        self.content = content()
    }
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                content
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton(), trailing: trailingButtons())
            .background(.white)
            .tint(ColorManager.shared.ciColor.highlightColor)
        } else {
            NavigationView {
                content
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton(), trailing: trailingButtons())
            .background(.white)
            .tint((ColorManager.shared.ciColor.highlightColor))
        }
        
    }
    
    private func backButton() -> some View {
        BackButton()
    }
    
    private func trailingButtons() -> some View {
        
        HStack {
            button
            SettingButton(inNavigationWrapper: true)
        }
        
    }
    
}

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
