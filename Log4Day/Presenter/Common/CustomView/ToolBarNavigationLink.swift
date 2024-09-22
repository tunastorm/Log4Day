//
//  ToolBarNavigationLink.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

struct ToolBarNavigationLink<NextView: View>: ToolbarContent {
    
    var id: String
    
    var placement: ToolbarItemPlacement
    
    var image: String
    
    var view: NextView
    
    var body: some ToolbarContent {
        ToolbarItem(id: id, placement: placement) {
            NavigationLink {
                NextViewWrapper(view)
            } label: {
                Image(systemName: image)
            }
            .foregroundStyle(.black)
            .buttonStyle(IsPressedButtonStyle(normalColor: .black, pressedColor: Resource.ciColor.highlightColor))
        }
    }
}
