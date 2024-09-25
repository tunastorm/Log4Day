//
//  addLogPlaceCell.swift
//  Log4Day
//
//  Created by 유철원 on 9/25/24.
//

import SwiftUI

struct NewLogPlaceCell: View {

    @ObservedObject var viewModel: NewLogViewModel
    @State private var isSelected: Bool = false
    
    var indexInfo: (Int,Int)
    var place: Place

    var body: some View {
        return cellView()
    }
    
    private func cellView() -> some View {
        VStack {
            HStack {
                numberingView(place.ofPhoto.map{ $0 })
                Spacer()
                contentsView()
            }
        }
        .frame(maxWidth: .infinity)
        .onTapGesture {
            if !viewModel.input.selectedPlace.contains(indexInfo.0) {
                isSelected = false
            }
            if isSelected {
                viewModel.input.selectedPlace.removeAll(where: { $0 == indexInfo.0 })
                print("\(indexInfo) 선택해제 됨")
            } else {
                viewModel.input.selectedPlace.append(indexInfo.0)
                print("\(indexInfo) 선택됨 ")
            }
            isSelected.toggle()
        }
    }

    private func numberingView(_ photo: [Photo]) -> some View {
        Text("\(photo.count)")
            .foregroundStyle(.white)
            .frame(width: 40, height: 40)
            .background(photo.count > 0 ? Resource.ciColor.highlightColor : Resource.ciColor.subContentColor )
            .clipShape(Circle())
    }
    
    private func contentsView() -> some View {
        VStack {
            Spacer()
            HStack {
                VStack {
                    HStack {
                        Text(place.name)
                            .font(.title3)
                            .bold()
                            .foregroundStyle(isSelected && viewModel.input.selectedPlace.contains(indexInfo.0) ?
                                             Resource.ciColor.highlightColor : Resource.ciColor.contentColor)
                        Spacer()
                    }
                    HStack {
                        Text(place.address)
                            .font(.caption)
                            .foregroundStyle(Resource.ciColor.subContentColor)
                        Spacer()
                    }
                }
                Button {
                 
                } label: {
                    Image(systemName: "camera")
                        .frame(width: 40, height: 40)
                        .foregroundStyle(Resource.ciColor.subContentColor)
                }
                .padding(.horizontal, 10)
            }
            .padding(.vertical)
            if indexInfo.0 < indexInfo.1 - 1 {
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Resource.ciColor.subContentColor)
            }
        }
        .padding(.leading)
    }
    
}
