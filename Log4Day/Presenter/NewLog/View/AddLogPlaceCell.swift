//
//  addLogPlaceCell.swift
//  Log4Day
//
//  Created by 유철원 on 9/25/24.
//

import SwiftUI

struct AddLogPlaceCell: View {

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
        .padding(.top)
    }

    private func numberingView(_ photo: [Photo]) -> some View {
        Text("\(photo.count)")
            .foregroundStyle(.white)
            .frame(width: 40, height: 40)
            .background(photo.count > 0 ? Resource.ciColor.highlightColor : Resource.ciColor.subContentColor  )
            .clipShape(Circle())
    }
    
    private func contentsView() -> some View {
        VStack {
            Rectangle()
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .foregroundStyle(Resource.ciColor.subContentColor)
            Spacer()
            VStack {
                HStack {
                    Text(place.name)
                        .font(.title3)
                        .bold()
                        .foregroundStyle(Resource.ciColor.contentColor)
                    Spacer()
                }
                HStack {
                    Text("#\(place.hashtag)")
                        .font(.caption)
                        .foregroundStyle(Resource.ciColor.subContentColor)
                    Spacer()
                }
            }
            .padding(.vertical)
            Rectangle()
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .foregroundStyle(Resource.ciColor.subContentColor)
        }
        .padding(.leading)
    }
    
}
