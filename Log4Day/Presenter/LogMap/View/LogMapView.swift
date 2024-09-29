//
//  LoglineView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI
import BottomSheet

struct LogMapView: View {
    
    @ObservedObject var categoryViewModel: CategoryViewModel
    @StateObject private var viewModel = LogMapViewModel()
    @StateObject private var logDetailViewModel = LogDetailViewModel()
   
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack {
                    NavigationBar(title: "LogMap", button:
                        Button(action: {
                            withAnimation(.spring()){
                                categoryViewModel.output.showSide.toggle()
                            }
                        }, label: {
                            Image(systemName: "tray")
                                .font(.system(size: 20))
                        })
                    )
                    LogNaverMapView(isFull: true,
                                    isDeleteMode: $logDetailViewModel.output.isDeleteMode,
                                    cameraPointer: $logDetailViewModel.output.cameraPointer,
                                    placeList: $logDetailViewModel.output.placeList,
                                    imageDict:  $logDetailViewModel.output.imageDict,
                                    coordinateList: $logDetailViewModel.output.coordinateList)
                }
                SideBarView(controller: .logMap, viewModel: categoryViewModel)
                    .environmentObject(viewModel)
            }
        }
        .bottomSheet(bottomSheetPosition: $logDetailViewModel.output.showPlaceListSheet, 
                     switchablePositions: [.dynamic]) {
            ScrollView {
                ForEach(logDetailViewModel.output.placeList.indices, id: \.self) { index in
                    LogDetailPlaceCell(viewModel: logDetailViewModel,
                                       indexInfo:(index, logDetailViewModel.output.placeList.count),
                                       place: logDetailViewModel.output.placeList[index])
                }
            }
            .frame(height: 300)
            .frame(maxWidth: .infinity)
            .background(.white)
        }
        .enableSwipeToDismiss()
    }

}
