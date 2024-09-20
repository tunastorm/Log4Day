//
//  ListHeaderView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

struct ListFooterView: View {
    
    var text: String
    
    var font: Font
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var baseColor: Color {
        colorScheme == .dark ? .white.opacity(0.3) : .black.opacity(0.25)
    }
 
    var body: some View {
        HStack {
            Text("Since: ")
                .font(.caption)
                .foregroundStyle(baseColor)
            Text(text)
                .font(font)
            Spacer()
        }
    }
}
