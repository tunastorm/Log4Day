//
//  CategoryAddSheet.swift
//  Log4Day
//
//  Created by 유철원 on 9/24/24.
//

import SwiftUI

struct AddCategorySheet: View {
    
    @ObservedObject var viewModel: CategoryViewModel
    
    var body: some View {
        VStack {
            TextField("추가할 카테고리 이름을 입력하세요", text: $viewModel.input.newCategory)
            Button {
                viewModel.action(.newCategoryTextFieldReturn)
                viewModel.action(.addTapped)
            } label: {
                Text("추가하기")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Resource.ciColor.backgroundColor)
    }
    
}

//#Preview {
//    AddCategorySheet()
//}
