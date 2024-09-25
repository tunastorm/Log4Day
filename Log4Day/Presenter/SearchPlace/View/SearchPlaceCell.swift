//
//  SearchPlaceCell.swift
//  Log4Day
//
//  Created by 유철원 on 9/25/24.
//

import SwiftUI

struct SearchPlaceCell: View {
    
    @State private var isSelected: Bool = false
    
    @ObservedObject var viewModel: SearchPlaceViewModel
    @ObservedObject var newLogViewModel: NewLogViewModel
    
    var place: SearchedPlace

    var body: some View {
        return cellView()
    }
    
    private func cellView() -> some View {
        VStack {
            HStack {
                selectButton()
                    .padding(.leading, 20)
                Spacer()
                contentsView()
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top)
    }

    private func selectButton() -> some View {
        Button {
            print("before 선택여부:",isSelected)
            if isSelected {
                newLogViewModel.action(.deleteButtonTapped(lastOnly: true))
            } else {
                newLogViewModel.action(.placePicked(place: place))
            }
            isSelected.toggle()
            print("after 선택여부:",isSelected)
        } label: {
            Image(systemName: "checkmark")
                .foregroundStyle(.white)
        }
        .frame(width: 40, height: 40)
        .background(isSelected ? Resource.ciColor.highlightColor : Resource.ciColor.subContentColor )
        .clipShape(Circle())
    }
    
    private func contentsView() -> some View {
        VStack {
            Spacer()
            VStack {
                HStack {
                    Text(place.title.replacingOccurrences(of: "<b>", with: "")
                                    .replacingOccurrences(of: "</b>", with: ""))
                        .font(.title3)
                        .bold()
                        .foregroundStyle(Resource.ciColor.contentColor)
                    Spacer()
                }
                HStack {
                    Text(place.roadAddress)
                        .font(.caption)
                        .foregroundStyle(Resource.ciColor.subContentColor)
                    Spacer()
                }
            }
            .padding(.vertical)
        }
        .padding(.leading)
    }
    
}
