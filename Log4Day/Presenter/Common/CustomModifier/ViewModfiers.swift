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

// Custom Half Modal Modifier
extension View {
    // Binding Show Vairables
    func halfSheet<SheetView: View> (
        showSheet: Binding<Bool>,
        @ViewBuilder sheetView: @escaping () -> SheetView,
        /* 새로 추가한 부분 */
        onEnd: @escaping ()->()
    ) -> some View {
        // why we using overlay or background
        // because it will automatically use the swiftui frame size only!
        return self.background {
                HalfSheetManager(
                    sheetView: sheetView(),
                    showSheet: showSheet,
                    /* 새로 추가한 부분*/
                    onEnd: onEnd
                )
            }
    }
}
