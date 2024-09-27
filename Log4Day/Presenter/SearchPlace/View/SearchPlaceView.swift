//
//  SearchPlaceView.swift
//  Log4Day
//
//  Created by 유철원 on 9/25/24.
//

import SwiftUI
import NMapsMap

struct SearchPlaceView: View {
    
    @StateObject private var viewModel = SearchPlaceViewModel()
    @ObservedObject var newLogViewModel: NewLogViewModel
    
    var body: some View {
        NavigationWrapper {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.output.placeList, id:\.id) { item in
                        let coordList = newLogViewModel.output.placeList.map { ($0.latitude, $0.longitude) }
                        let isPicked = viewModel.checkIsPicked((item.mapX, item.mapY), coordList)
                        SearchPlaceCell(isPicked: isPicked,
                                               viewModel: viewModel,
                                               newLogViewModel: newLogViewModel,
                                               place: item
                        )
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
