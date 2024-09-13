//
//  View+Extension.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func hideIndicator() -> some View {
        if #available(iOS 16, *) {
            self.modifier(Ios16_HideIndicator())
        } else {
            self.modifier(Ios15_HideIndicator())
        }
    }
}

@available(iOS 16, *)
struct Ios16_HideIndicator: ViewModifier {
    
    func body(content: Content) -> some View {
        content.scrollIndicators(.hidden)
    }
}


struct Ios15_HideIndicator: ViewModifier {
    
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    func body(content: Content) -> some View {
        content
    }
}
