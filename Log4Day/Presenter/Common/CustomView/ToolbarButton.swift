//
//  ToolBars.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

struct ToolbarButton: ToolbarContent {
    
    var id: String
    
    var placement: ToolbarItemPlacement
    
    var image: String
    
    var action: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItem(id: id, placement: placement) {
            Button(action: {
                action()
            }, label: {
                Image(systemName: image)
            })
            .foregroundStyle(.black)
            .buttonStyle(IsPressedButtonStyle(normalColor: .black, pressedColor: .mint, isAnimated: true))
        }
    }
    
}
