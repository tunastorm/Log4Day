//
//  SearchPlaceView.swift
//  Log4Day
//
//  Created by 유철원 on 9/25/24.
//

import SwiftUI

struct SearchPlaceView: View {
    
    @StateObject private var viewModel = SearchPlaceViewModel()
     
    var body: some View {
        NavigationWrapper {
            ScrollView {
                LazyVStack {
                    
                }
            }
            .searchable( // <-
                text: $viewModel.output.searchKeyword,
                placement: .navigationBarDrawer,
                prompt: "장소를 입력하세요"
            )
            .onSubmit(of: .search) {
                
            }
        }
    }
    
    
    
}

#Preview {
    SearchPlaceView()
}
