//
//  PlaceCell.swift
//  Log4Day
//
//  Created by 유철원 on 9/21/24.
//
import SwiftUI
import RealmSwift

struct PlaceCell: View {
    
    @EnvironmentObject var viewModel: MyLogViewModel
    
    var index: Int
    var total: Int
    var placeName: String
    var photoCount: Int
    var placeAdress: String

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
                numberingView(photoCount)
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
    }

    private func numberingView(_ photoCount: Int) -> some View {
        Text("\(photoCount)")
            .foregroundStyle(.white)
            .frame(width: 40, height: 40)
            .background(photoCount > 0 ? ColorManager.shared.ciColor.highlightColor : ColorManager.shared.ciColor.subContentColor)
            .clipShape(Circle())
    }
    
    private func contentsView() -> some View {
        VStack {
            Spacer()
            VStack {
                HStack {
                    Text(placeName)
                        .font(.title3)
                        .bold()
                        .foregroundStyle(ColorManager.shared.ciColor.contentColor)
                    Spacer()
                }
                HStack {
                    Text(placeAdress)
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
