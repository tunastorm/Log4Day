//
//  SwiftUIView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

struct NavigationWrapper<Trailing: View, Content: View>: View {
    
    let button: Trailing
    let content: Content
    let dismissHandler: () -> Void
    
    init(@ViewBuilder button: (() -> Trailing),
         @ViewBuilder content: () -> Content,
         dismissHandler: @escaping () -> Void) {
        self.button = button()
        self.content = content()
        self.dismissHandler = dismissHandler
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
        BackButton(dismissHandler: dismissHandler)
    }
    
    private func trailingButtons() -> some View {
        HStack {
            button
//            SettingButton(inNavigationWrapper: true)
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
        NotificationCenter.default.post(name: NSNotification.Name("DismissedWithSwipe"),
                                        object: nil,
                                        userInfo: nil)
        return viewControllers.count > 1
    }
    
}
