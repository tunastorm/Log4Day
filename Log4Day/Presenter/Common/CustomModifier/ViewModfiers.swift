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

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}

extension View {
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
}

// @available(iOS 13.4, *) - needed for iOS
struct Draggable: ViewModifier {
    
    let condition: Bool
    let data: () -> NSItemProvider
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if condition {
            content.onDrag(data)
        } else {
            content
        }
    }
    
}


extension View {
    
    public func drag(if condition: Bool, data: @escaping () -> NSItemProvider) -> some View {
        self.modifier(Draggable(condition: condition, data: data))
    }
    
}
