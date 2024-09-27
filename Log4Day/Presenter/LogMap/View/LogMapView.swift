//
//  LoglineView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI
import CoreLocation

struct LogMapView: View {
    
    @ObservedObject var categoryViewModel: CategoryViewModel
    @StateObject private var viewModel = LogMapViewModel()
    
    @State private var selectedCategory = "전체"
    
    @State private var showSide = false
    
    @State private var showMapView = false
    
    @State private var coord: (CLLocationDegrees, CLLocationDegrees) = (126.9784147, 37.5666805)
    
    var locationManager = CLLocationManager()
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack {
                    NavigationBar(title: "LogMap", button:
                        Button(action: {
                            withAnimation(.spring()){
                                showSide.toggle()
                            }
                        }, label: {
                            Image(systemName: "tray")
                                .font(.system(size: 20))
                        })
                    )
                    LogNaverMapView(isFull: true,
                                    cameraPointer: $viewModel.output.cameraPointer,
                                    placeList: $viewModel.output.placeList,
//                                    photoDict: $viewModel.output.photoDict,
                                    imageDict:  $viewModel.output.imageDict,
                                    coordinateList: $viewModel.output.coordinateList
                              
                    )
                    .padding(.bottom, 130)
                }
                SideBarView(controller: .logMap, viewModel: categoryViewModel)
                    .environmentObject(viewModel)
            }
        }
        .task {
            await startTask()
        }
    }
    
    private func timeline() -> some View {
        LazyVStack {
            ForEach(0..<100) { index in
//                TimelineCell(index: index)
            }
        }
        .background(.clear)
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    private func startTask() async {
        // 위치 사용 권한 설정 확인
        let authorizationStatus = locationManager.authorizationStatus
        
        print(#function, "위치권한상태:", authorizationStatus.rawValue)
        
        // 위치 사용 권한 거부되어 있음
        if authorizationStatus == .denied {
            // 앱 설정화면으로 이동
            print("위치 사용 권한: 거부")
            DispatchQueue.main.sync {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        }
        // 위치 사용 권한 대기 상태
        if authorizationStatus == .restricted || authorizationStatus == .notDetermined {
            // 권한 요청 팝업창
            print("위치 사용 권한: 대기 상태")
            locationManager.requestWhenInUseAuthorization()
        }
        // 위치 사용 권한 항상 허용되어 있음
        if authorizationStatus == .authorizedAlways {
            print("위치 사용 권한: 항상 허용")
        }
        // 위치 사용 권한 앱 사용 시 허용되어 있음
        else if authorizationStatus == .authorizedWhenInUse {
            print("위치 사용 권한: 앱 사용 시 허용")
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        DispatchQueue.main.async {
            print("setHereLocation")
            setHereLocation()
        }
    }
    
    private func setHereLocation() {
        guard let coordinate = CLLocationManager().location?.coordinate else {
            print("위경도 정보 없음")
            return
        }
        showMapView = true
        self.coord = (coordinate.longitude, coordinate.latitude)
        
        print("현재 위경도: ", coordinate)
    }

}

//
//#Preview {
//    LogMapView()
//}
