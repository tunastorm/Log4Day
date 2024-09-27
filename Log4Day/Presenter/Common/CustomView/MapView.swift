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
//    @Binding var photoDict: [Int:[Photo]]?
    @Binding var imageDict: [Int:[UIImage]]
    @Binding var coordinateList: [NMGLatLng]
    
    var body: some View {
        return UIMapView(cameraPointer: $cameraPointer, placeList: $placeList, imageDict: $imageDict, coordinateList: $coordinateList)
            .edgesIgnoringSafeArea(.vertical)
        .frame(height: isFull ? UIScreen.main.bounds.height : 300)
        .frame(maxWidth: .infinity)
    }
    
}


