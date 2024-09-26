//
//  NaverMapRepresentable.swift
//  Log4Day
//
//  Created by 유철원 on 9/20/24.
//

import SwiftUI
import NMapsMap

struct UIMapView: UIViewRepresentable {
    
    @Binding var cameraPointer: Int
    @Binding var placeList: [Place]
    @Binding var photoList: [Photo]
    
    enum OverlayImage: CaseIterable {

        case blue
        case gray
        case green
        case lightBlue
        case pink
        case red
        case yellow
        case black
        
        var image: NMFOverlayImage {
            switch self {
            case .green: NMF_MARKER_IMAGE_GREEN
            case .blue: NMF_MARKER_IMAGE_BLUE
            case .gray: NMF_MARKER_IMAGE_GRAY
            case .lightBlue: NMF_MARKER_IMAGE_LIGHTBLUE
            case .pink: NMF_MARKER_IMAGE_PINK
            case .red: NMF_MARKER_IMAGE_RED
            case .yellow: NMF_MARKER_IMAGE_YELLOW
            case .black: NMF_MARKER_IMAGE_BLACK
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        
        return Coordinator()
    }

    func makeUIView(context: Context) -> NMFNaverMapView {
        let view = NMFNaverMapView()
        view.showScaleBar = true
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        view.mapView.zoomLevel = 15
        view.mapView.allowsScrolling = true
        view.mapView.addCameraDelegate(delegate: context.coordinator)
        return view
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        print("현재 focusIndex:", cameraPointer)
        var photoDict: [Int : Photo] = [:]
        photoList.enumerated().forEach { index, photo in
            guard let photoPlace = photo.owner.first else {
                return
            }
            let filtered = placeList.filter { $0 == photoPlace }
            if filtered.count > 0 {
                photoDict[index] = photo
            }
        }
        var coordinateList: [NMGLatLng] = []
     
        placeList.enumerated().forEach { index, place in
            let nmgLatlng = NMGLatLng(lat: place.latitude, lng: place.longitude)
            print(#function, "위경도:",nmgLatlng)
            coordinateList.append(nmgLatlng)
            let overLayImage = OverlayImage.allCases[index % 8].image
            let marker = NMFMarker(position: nmgLatlng, iconImage: overLayImage)
            marker.position = nmgLatlng
            marker.mapView = uiView.mapView
        }
        if let polyline = NMFPolylineOverlay(coordinateList) {
            polyline.width = 3
            polyline.color = .systemGray2
            polyline.pattern = [6,3]
            polyline.mapView = uiView.mapView
        }
        
        guard placeList.count > 0  else {
            return
        }
        print("카메라 포인터:", cameraPointer)
        let nmgLatlng = NMGLatLng(lat: placeList[cameraPointer].latitude,
                                  lng: placeList[cameraPointer].longitude)
        let cameraUpdate = NMFCameraUpdate(scrollTo: nmgLatlng)
        cameraUpdate.animation = .none
        cameraUpdate.animationDuration = 1
        uiView.mapView.moveCamera(cameraUpdate)
    }
    
    class Coordinator: NSObject, NMFMapViewCameraDelegate {
        
        func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
            print("카메라 변경 - reason: \(reason)")
            
        }

        func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
            print("카메라 변경 - reason: \(reason)")
        }
        
    }

}
