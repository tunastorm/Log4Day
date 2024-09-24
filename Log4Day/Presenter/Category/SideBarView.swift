//
//  SideBarView.swift
//  Log4Day
//
//  Created by 유철원 on 9/20/24.
//

import SwiftUI
import RealmSwift

struct SideBarView: View {
    
    var controller: Contoller
    
    @ObservedObject var viewModel: CategoryViewModel
    @EnvironmentObject private var myLogViewModel: MyLogViewModel
    @EnvironmentObject private var logMapViewModel: LogMapViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .opacity(viewModel.output.showSide ? 0.6 : 0)
                .onTapGesture {
                    withAnimation {
                        viewModel.action(.sideBarButtonTapped)
                    }
                }
            HStack {
                if myLogViewModel != nil {
                    SideView(controller: controller, viewModel: viewModel)
                        .environmentObject(myLogViewModel)
                } else {
                    
                }
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.clear)
            }
            .frame(height: UIScreen.main.bounds.height)
        }
    }
    
    
}
