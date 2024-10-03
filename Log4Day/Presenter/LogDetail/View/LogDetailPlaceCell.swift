//
//  addLogPlaceCell.swift
//  Log4Day
//
//  Created by 유철원 on 9/25/24.
//

import SwiftUI
import PhotosUI

struct LogDetailPlaceCell: View {
    
    var controller: Controller
    
    @ObservedObject var viewModel: LogDetailViewModel
    @State private var isSelected: Bool = false
    @State private var showPicker: Bool = false
    
    var indexInfo: (Int,Int)
    var place: Place

    var pickerConfig: (Int) -> PHPickerConfiguration = { limit in
          var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
          config.filter = .images
          config.selection = .ordered
          config.selectionLimit = limit
          config.preferredAssetRepresentationMode = .current // 트랜스 코딩을 방지
          return config
    }
    
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
        Text("\(photoCount)")
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
                        Text(place.address)
                            .font(.caption)
                            .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
                        Spacer()
                    }
                }
                if controller == .newLogView {
                    Button {
                        showPicker.toggle()
                        viewModel.output.cameraPointer = indexInfo.0
                    } label: {
                        Image(systemName: "camera")
                            .frame(width: 40, height: 40)
                            .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
                    }
                    .padding(.horizontal, 10)
                    .sheet(isPresented: $showPicker, content: {
                        let limit = 4 - viewModel.output.imageDict.values.flatMap{ $0 }.count
                        return PhotoPicker(viewModel: viewModel,
                                    isPresented: $showPicker,
                                    configuration: pickerConfig(limit))
                            .ignoresSafeArea()
                    })
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
