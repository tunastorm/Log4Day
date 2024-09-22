//
//  SideView.swift
//  Log4Day
//
//  Created by 유철원 on 9/15/24.
//

import SwiftUI
import RealmSwift

struct SideView: View {
    
    @EnvironmentObject private var viewModel: CategoryViewModel
    @Namespace var namespace
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.white
            VStack {
                titleView()
                Spacer()
                categoryListView()
            }
        }
        .frame(width: 240)
        .frame(maxHeight: .infinity)
        .offset(x: viewModel.output.showSide ? 0 : -248)
    }
    
    private func titleView() -> some View {
        VStack {
            HStack {
                Text("카테고리")
                    .font(.headline)
                    .foregroundColor(Resource.ciColor.highlightColor)
                Spacer()
                Button {
                    withAnimation {
                        viewModel.action(.sideBarButtonTapped)
                    }
                } label: {
                    Image(systemName: "xmark")
                }
                .padding(.trailing)
                .foregroundStyle(Resource.ciColor.contentColor)
            }
            .padding(.leading)
            .padding(.top)
            Rectangle()
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .foregroundStyle(Resource.ciColor.subContentColor)
        }
    }
    
    private func categoryListView() -> some View {
        ScrollView {
            ForEach(viewModel.output.categoryList, id: \.id) { item in
                HStack {
                    SidebarButton(title: item.title, namespace: namespace)
                        .environmentObject(viewModel)
                }
            }
        }
        .padding(.init(top: 0, leading: 0, bottom: 140, trailing: 0))
    }
    
    private func buttonView() -> some View {
        HStack {
            Button {
                viewModel.action(.deleteTapped)
            } label: {
                Text("삭제하기")
            }
            .padding(.horizontal)
            .alert(LocalizedStringKey("삭제"), isPresented: $viewModel.output.deleteAlert) {
                Text("삭제")
                Text("취소")
            }
            Rectangle()
                .frame(width: 1)
                .frame(maxHeight: .infinity)
                .padding(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                .foregroundStyle(Resource.ciColor.subContentColor)
            Button {
                viewModel.action(.addTapped)
            } label: {
                Text("추가하기")
            }
            .padding(.horizontal)
            .alert(LocalizedStringKey("추가"), isPresented: $viewModel.output.addAlert) {
                Text("추가")
                Text("취소")
            }
          
        }
        .frame(height: 40)
        .frame(maxWidth: .infinity)
    }
    
}
