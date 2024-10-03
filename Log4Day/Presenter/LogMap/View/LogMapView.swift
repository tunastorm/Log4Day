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
   
    @State var showDatePicker = true
    
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
                    ZStack {
                        LogNaverMapView(isFull: true,
                                        cameraPointer: $logDetailViewModel.output.cameraPointer,
                                        placeList: $logDetailViewModel.output.placeList,
                                        imageDict:  $logDetailViewModel.output.imageDict,
                                        coordinateList: $logDetailViewModel.output.coordinateList)
                        if showDatePicker {
                            VStack {
                                HorizontalCalendarView(viewModel: viewModel)
                                Spacer()
                            }
                        }
                    }
                }
                SideBarView(controller: .logMap, viewModel: categoryViewModel)
                    .environmentObject(viewModel)
            }
        }
        .onAppear {
//            viewModel.action(.fetchFirstLastDate)
            viewModel.action(.initialFetch)
        }
        .bottomSheet(bottomSheetPosition: $logDetailViewModel.output.showPlaceListSheet,
                     switchablePositions: [.hidden, .dynamic]) {
            ScrollView {
                ForEach(logDetailViewModel.output.placeList.indices, id: \.self) { index in
                    LogDetailPlaceCell(controller: .logMap,
                                       viewModel: logDetailViewModel,
                                       indexInfo:(index, logDetailViewModel.output.placeList.count),
                                       place: logDetailViewModel.output.placeList[index])
                }
            }
            .frame(height: 300)
            .frame(maxWidth: .infinity)
            .background(.white)
        }
        .showDragIndicator(false)
        .enableContentDrag()
        .enableSwipeToDismiss()
        .enableTapToDismiss()
        .showCloseButton()
    }

}
