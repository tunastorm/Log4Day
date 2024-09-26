//
//  CategoryAddSheet.swift
//  Log4Day
//
//  Created by 유철원 on 9/24/24.
//

import SwiftUI

struct AddCategorySheet: View {
    
    @FocusState var isFocused: Bool

    @ObservedObject var viewModel: CategoryViewModel
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    TextField("추가할 카테고리 이름을 입력하세요", text: $viewModel.input.newCategory)
                        .focused($isFocused)
                    Rectangle()
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
                    
                        .padding()
                }
                .padding(.top, 20)
                HStack {
                    Spacer()
                    Button {
                        viewModel.action(.newCategoryTextFieldReturn)
                        viewModel.action(.addTapped)
                        isFocused = false
                    } label: {
                        Text("추가하기")
                    }
                    Spacer()
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: isFocused ? 500 : 350)
            .background(ColorManager.shared.ciColor.backgroundColor)
        }
        
    }
}

//#Preview {
//    AddCategorySheet()
//}
