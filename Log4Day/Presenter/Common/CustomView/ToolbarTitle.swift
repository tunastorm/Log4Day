//
//  TabTitle.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

struct ToolbarTitle: ToolbarContent {
    
    var text: String
    
    var placement: ToolbarItemPlacement
    
    var body: some ToolbarContent {
        ToolbarItem(id: "tabTitle", placement: placement) {
            Text(text)
                .frame(width: 80, height: 40)
                .font(.headline)
                .foregroundStyle(Resource.ciColor.highlightColor)
        }
    }
    
}
