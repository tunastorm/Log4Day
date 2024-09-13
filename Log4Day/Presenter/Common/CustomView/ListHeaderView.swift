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
    
    var color: Color
    
    var body: some View {
        HStack {
            Text(text)
                .font(font)
                .foregroundStyle(color)
            Spacer()
        }
    }
}
