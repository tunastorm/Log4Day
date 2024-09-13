//
//  CustomButtonStyle.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

struct IsPressedButtonStyle: ButtonStyle {
    
    var normalColor: Color
    
    var pressedColor: Color
    
    var isAnimated: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(configuration.isPressed ?  pressedColor : normalColor )
            .animation(isAnimated ? .spring : nil, value: 2.0)
            .scaleEffect(configuration.isPressed ? (isAnimated ? 1.3 : 1.0) : 1.0)
    }
}
