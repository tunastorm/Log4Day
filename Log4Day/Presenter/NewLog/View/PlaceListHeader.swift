//
//  PlaceListHeader.swift
//  Log4Day
//
//  Created by 유철원 on 10/4/24.
//

import SwiftUI

struct PlaceListHeader: View {
    
    @ObservedObject var viewModel: LogDetailViewModel
    
    var body: some View {
        VStack{
            if !viewModel.output.placeList.isEmpty {
                HStack {
                    Spacer()
                    Text("네컷사진 \(viewModel.output.imageDict.values.flatMap({$0}).count) / 4")
                        .padding(.horizontal, 5)
                        .foregroundStyle(viewModel.output.imageDict.values.flatMap({$0}).count == 4 ?  ColorManager.shared.ciColor.highlightColor : ColorManager.shared.ciColor.contentColor)
                }
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
            }
        }
        .background(.white)
       
    }
}
