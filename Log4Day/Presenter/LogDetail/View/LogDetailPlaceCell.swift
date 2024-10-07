//
//  addLogPlaceCell.swift
//  Log4Day
//
//  Created by 유철원 on 9/25/24.
//

import SwiftUI

struct LogDetailPlaceCell: View {
    
    var controller: Controller
    
    @ObservedObject var viewModel: LogDetailViewModel
    @State private var isSelected: Bool = false
    
    var indexInfo: (Int,Int)
    var place: Place

    var body: some View {
        return cellView()
    }
    
    private func cellView() -> some View {
        VStack {
            HStack {
                numberingView(viewModel.output.imageDict[indexInfo.0]?.count ?? 0)
                Spacer()
                contentsView()
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            isSelected = viewModel.output.cameraPointer == indexInfo.0
        }
        .onTapGesture {
            viewModel.output.cameraPointer = indexInfo.0
        }
        .onChange(of: viewModel.output.cameraPointer == indexInfo.0) { isSelected in
            self.isSelected = isSelected
        }
    }

    private func numberingView(_ photoCount: Int) -> some View {
        Text("\(indexInfo.0 + 1)")
            .foregroundStyle(.white)
            .frame(width: 40, height: 40)
            .background(isSelected ? ColorManager.shared.ciColor.highlightColor : ColorManager.shared.ciColor.subContentColor )
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
                            .foregroundStyle(isSelected ?
                                            ColorManager.shared.ciColor.highlightColor : ColorManager.shared.ciColor.contentColor)
                        Spacer()
                    }
                    HStack {
                        Text(place.ofPhoto.isEmpty ?
                             viewModel.output.imageDict[indexInfo.0]?.isEmpty ?? true ? "사진 없음" : "사진 \(viewModel.output.imageDict[indexInfo.0]?.count ?? 0)장"
                             : "사진 \(place.ofPhoto.count)장"
                        )
                        .font(.caption)
                        .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
                        Spacer()
                    }
                }
                if controller == .newLogView, isSelected {
                    Button {
                        viewModel.action(.placeEditButtonTapped)
                    } label: {
                        Text("편집")
                            .font(.body)
                            .foregroundStyle(ColorManager.shared.ciColor.highlightColor)
                    }
                    .padding(.horizontal, 10)
                }
            }
            .padding(.vertical)
            if indexInfo.0 < indexInfo.1 - 1 {
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
            }
        }
        .padding(.leading)
    }
    
}
