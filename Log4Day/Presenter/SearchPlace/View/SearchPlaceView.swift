//
//  SearchPlaceView.swift
//  Log4Day
//
//  Created by 유철원 on 9/25/24.
//

import SwiftUI

struct SearchPlaceView: View {
    
    @StateObject private var viewModel = SearchPlaceViewModel()
    @ObservedObject var newLogViewModel: NewLogViewModel
    
    var body: some View {
        NavigationWrapper {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.output.placeList, id:\.id) { item in
                        SearchPlaceCell(viewModel: viewModel, 
                                        newLogViewModel: newLogViewModel,
                                        place: item)
                    }
                }
            }
            .searchable( // <-
                text: $viewModel.input.searchKeyword,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "장소를 입력하세요"
            )
            .onSubmit(of: .search) {
                viewModel.action(.search)
            }
        }
    }
    
    
    
}
