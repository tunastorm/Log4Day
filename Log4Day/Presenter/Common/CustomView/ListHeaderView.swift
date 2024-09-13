//
//  ListHeaderView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

struct ListHeaderView: View {
    
    var text: String
    
    var font: Font
    
    var firstLogDate: String = "24.01.01"
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var baseColor: Color {
        colorScheme == .dark ? .white.opacity(0.3) : .black.opacity(0.25)
    }
 
    var body: some View {
        HStack {
            Text("Subject: ")
                .foregroundStyle(baseColor)
            Text(text)
                .font(font)
            Spacer()
            Text("Since: ")
                .foregroundStyle(baseColor)
            Text(firstLogDate)
        }
    }
}
