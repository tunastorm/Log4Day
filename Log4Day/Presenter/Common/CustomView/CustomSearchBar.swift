//
//  CustomSearchBar.swift
//  Log4Day
//
//  Created by 유철원 on 10/3/24.
//

import SwiftUI

struct CustomSearchBar: View {
    
    @Binding var text: String
 
    var onSubmitHandler: () -> Void
    
    var onChangeHandler: () -> Void
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
 
                TextField("장소를 입력하세요", text: $text) {
                    onSubmitHandler()
                }
                if !text.isEmpty {
                    Button {
                        text = " "
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                } else {
                    EmptyView()
                }
            }
            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            .foregroundColor(.secondary)
           
        }
        .frame(height: 40)
        .background(.systemGray5)
        .cornerRadius(10.0)
        .padding(.vertical, 4)
        .padding(.horizontal)
    }

}
