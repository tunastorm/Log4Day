//
//  BottomSheetHeaderView.swift
//  Log4Day
//
//  Created by 유철원 on 10/3/24.
//

import SwiftUI

struct BottomSheetHeaderView: View {
    
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
                .padding(.leading)
            Spacer()
        }
        .padding(.vertical,20)
    }
}

