//
//  CategoryPickerView.swift
//  Log4Day
//
//  Created by 유철원 on 9/28/24.
//

import SwiftUI

struct CategoryPickerView: View {
    
    @ObservedObject var categoryViewModel: CategoryViewModel
    @ObservedObject var viewModel: LogDetailViewModel
    
    var body: some View {
        let title = viewModel.output.category == "" ? "카테고리 없음" : viewModel.output.category
        return HStack {
            Menu("▼ \(title)") {
                ForEach(setCategoryList(), id: \.self) { category in
                    if category != "추가" {
                        Button(action: {
                            viewModel.output.category = category
                        }, label: {
                            Text(category)
                                .foregroundStyle(Color.black)
                                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                        })
                    } else {
                        Button(action: {
                            categoryViewModel.action(.showAddSheet)
                        }, label: {
                            Label {
                                Text(category)
                                    .foregroundStyle(Color.black)
                                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                            } icon: {
                                Image(systemName: "plus")
                            }

                        })
                    }
                }
            }
            .font(.footnote)
            .frame(height: 30)
            .frame(minWidth: 50)
            .padding(.vertical, 1)
            .padding(.horizontal, 8)
            .foregroundStyle(Color.white)
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.systemMint))
            Spacer()
        }
    }
    
    private func setCategoryList() -> [String] {
        var list = Array(categoryViewModel.output.categoryList.map{ $0.title })
        list.insert("카테고리 없음", at: 0)
        list.append("추가")
        return list
    }
    
}
