//
//  PhotoBannerItemView.swift
//  Log4Day
//
//  Created by 유철원 on 9/19/24.
//

import SwiftUI

struct PhotoBannerItemView: View {
    
    @Binding var pageIndex: Int
    @Binding var pageTotal: Int
    
    var body: some View {
        VStack {
            HStack {
                Capsule()
                    .foregroundColor(Color(.secondarySystemBackground))
                    .frame(width: 40, height: 15)
                    .padding()
                    .overlay {
                        Text("\(pageIndex+1)/\(pageTotal)")
                            .foregroundStyle(.primary)
                        font(.caption)
                    }
                Spacer()
            }
            Spacer()
        }
    }
}
