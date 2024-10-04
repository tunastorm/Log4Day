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
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                VStack {
                    VStack {
                        TextField("추가할 카테고리 이름을 입력하세요", text: $viewModel.input.newCategory)
                            .focused($isFocused)
                        Rectangle()
                            .frame(height: 1)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
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
                }
            }
            .padding(.bottom, isFocused ? 40 : 90)
        }
        .frame(height: isFocused ? 170 : 250)
        .animation(.easeInOut, value: isFocused)
        .background(ColorManager.shared.ciColor.backgroundColor)
    }
}

//#Preview {
//    AddCategorySheet()
//}
