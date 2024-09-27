//
//  MapView.swift
//  Log4Day
//
//  Created by 유철원 on 9/20/24.
//

import NMapsMap
import SwiftUI

struct LogNaverMapView: View {
    var isFull: Bool = false
    @Binding var cameraPointer: Int
    @Binding var placeList: [Place]
    @Binding var photoDict: [Int : Photo]
    @Binding var coordinateList: [NMGLatLng]
    
    var body: some View {
        print("네이버 맵뷰 장소목록:",placeList.count)
        print("장소: ", placeList.first?.name)
        print("카메라 포인터:", cameraPointer)
        return ZStack {
            UIMapView(cameraPointer: $cameraPointer, placeList: $placeList, photoDict: $photoDict, coordinateList: $coordinateList)
                .edgesIgnoringSafeArea(.vertical)
        }
        .frame(height: isFull ? UIScreen.main.bounds.height : 300)
        .frame(maxWidth: .infinity)
    }
    
}


