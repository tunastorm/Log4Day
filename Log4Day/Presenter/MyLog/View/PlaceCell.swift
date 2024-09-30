//
//  PlaceCell.swift
//  Log4Day
//
//  Created by 유철원 on 9/21/24.
//
import SwiftUI

struct PlaceCell: View {
    
    @EnvironmentObject var viewModel: MyLogViewModel
    
    var index: Int
    var total: Int
    var place: Place

    var body: some View {
        return cellView()
    }
    
    private func cellView() -> some View {
        VStack {
            if index == 0 {
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
            }
            HStack {
                numberingView(place.ofPhoto.map{ $0 })
                Spacer()
                contentsView()
            }
            if index == total-1 {
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top)
    }

    private func numberingView(_ photo: [Photo]) -> some View {
        Text("\(photo.count)")
            .foregroundStyle(.white)
            .frame(width: 40, height: 40)
            .background(photo.count > 0 ? ColorManager.shared.ciColor.highlightColor : ColorManager.shared.ciColor.subContentColor)
            .clipShape(Circle())
    }
    
    private func contentsView() -> some View {
        VStack {
            Spacer()
            VStack {
                HStack {
                    Text(place.name)
                        .font(.title3)
                        .bold()
                        .foregroundStyle(ColorManager.shared.ciColor.contentColor)
                    Spacer()
                }
                HStack {
                    Text(place.address)
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
                    Spacer()
                }
            }
            .padding(.vertical)
            if index < total-1 {
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
            }
        }
        .padding(.leading)
    }
    
}
