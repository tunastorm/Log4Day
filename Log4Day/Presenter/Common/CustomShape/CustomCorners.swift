//
//  CustomCorners.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

//Custom Corner Shapes
struct CustomCorners: Shape {
    
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
    
}
