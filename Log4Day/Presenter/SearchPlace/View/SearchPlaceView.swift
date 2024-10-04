//
//  SearchPlaceView.swift
//  Log4Day
//
//  Created by 유철원 on 9/25/24.
//

import SwiftUI
import UIKit
import NMapsMap

struct SearchPlaceView: View {
    
    @StateObject private var viewModel = SearchPlaceViewModel()
    @ObservedObject var newLogViewModel: LogDetailViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationWrapper { 
            Text("")
        } content: {
            VStack {
                CustomSearchBar(text: $viewModel.input.searchKeyword) {
                    viewModel.action(.search)
                } onChangeHandler: {
                    viewModel.action(.search)
                }
                if viewModel.input.searchKeyword == "" {
                    VStack(alignment: .center) {
                        Spacer()
                        Text("추억을 만든 장소를 검색하세요")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                } else {
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
                    HStack {
                        Spacer()
                        Button {
                            newLogViewModel.input.pickedPlaces.removeAll()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                presentationMode.wrappedValue.dismiss()
                            }
                        } label: {
                            Text("추가하기")
                                .foregroundStyle(.white)
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(ColorManager.shared.ciColor.highlightColor)
                                .cornerRadius(10, corners: .allCorners)
                                .padding(.top, 10)
                                .padding(.horizontal)
                                .padding(.bottom)
                        }
                        Spacer()
                    }
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                }
            }
        } dismissHandler: {
            newLogViewModel.action(.cancelPickedPlaces)
        }
    }

}
