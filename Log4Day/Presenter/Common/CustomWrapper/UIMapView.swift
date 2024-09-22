//
//  NaverMapRepresentable.swift
//  Log4Day
//
//  Created by 유철원 on 9/20/24.
//

import SwiftUI
import NMapsMap

struct UIMapView: UIViewRepresentable {
    
    @Binding var coord: (Double, Double)

    func makeCoordinator() -> Coordinator {
        Coordinator(coord)
    }

    func makeUIView(context: Context) -> NMFNaverMapView {
        let view = NMFNaverMapView()
        view.showZoomControls = true
        view.showScaleBar = true
        view.showLocationButton = true
        view.mapView.positionMode = .direction
        view.mapView.zoomLevel = 17
        view.mapView.addCameraDelegate(delegate: context.coordinator)
        
        return view
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        let coord = NMGLatLng(lat: coord.1, lng: coord.0)
        let cameraUpdate = NMFCameraUpdate(scrollTo: coord)
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1
        uiView.mapView.moveCamera(cameraUpdate)
    }
    
//
    class Coordinator: NSObject, NMFMapViewCameraDelegate {
        var coord: (Double, Double)
        init(_ coord: (Double, Double)) {
            self.coord = coord
        }
        
        func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
//            print("카메라 변경 - reason: \(reason)")
        }

        func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
//            print("카메라 변경 - reason: \(reason)")
        }
    }

}
