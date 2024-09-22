//
//  SideBarView.swift
//  Log4Day
//
//  Created by 유철원 on 9/20/24.
//

import SwiftUI
import RealmSwift

struct SideBarView: View {
    
    @EnvironmentObject private var viewModel: CategoryViewModel
    
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
                SideView()
                    .environmentObject(viewModel)
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.clear)
            }
            .frame(height: UIScreen.main.bounds.height)
        }
    }
    
    
}
