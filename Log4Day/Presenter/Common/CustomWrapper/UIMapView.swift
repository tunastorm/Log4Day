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
    @Binding var photoDict: [Int : Photo]
    @Binding var coordinateList: [NMGLatLng]
    
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
        
        let coordinator = Coordinator()
    
        return coordinator
        
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
        
        context.coordinator.exchangeOverlays(newCoordList: coordinateList)
        
        print("현재 focusIndex:", cameraPointer)
        print("장소목록: ",placeList.count)
        
        if context.coordinator.isDeleted {
            context.coordinator.cameraPointer = placeList.count - 1
        } else {
            context.coordinator.cameraPointer = cameraPointer
        }
        
        cameraPointer = context.coordinator.cameraPointer
        
        context.coordinator.markerList.forEach { $0.mapView = uiView.mapView }
        
        if let polyline = context.coordinator.polyline {
        
            context.coordinator.polyline?.mapView = uiView.mapView
        
        } else if let newline = NMFPolylineOverlay(coordinateList) {
            newline .width = 3
            newline .color = .systemGray3
            newline .pattern = [6,3]
            newline .mapView = uiView.mapView
            context.coordinator.polyline = newline
        }
        
        // 사진 표시 로직 구현
        if placeList.count > 0 {
            print(#function, "카메라 포인터:", cameraPointer)
            
            let pointer = cameraPointer == context.coordinator.cameraPointer ?
                cameraPointer : context.coordinator.cameraPointer
        
            let nmgLatlng = NMGLatLng(lat: placeList[pointer].latitude,
                                      lng: placeList[pointer].longitude)
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: nmgLatlng)
            cameraUpdate.animation = .none
            cameraUpdate.animationDuration = 1
            uiView.mapView.moveCamera(cameraUpdate)
        }
        
    }
    
    class Coordinator: NSObject, NMFMapViewCameraDelegate {
        
        var isDeleted: Bool = false
        var cameraPointer: Int = 0
        var markerList: [NMFMarker] = []
        var coordinateList: [NMGLatLng] = []
        var polyline: NMFPolylineOverlay?
        
        func exchangeOverlays(newCoordList: [NMGLatLng]) {
            var oldSet = Set<NMGLatLng>()
            var newSet = Set<NMGLatLng>()
            coordinateList.forEach { oldSet.insert($0) }
            newCoordList.forEach { newSet.insert($0) }
            
            let filteredOld = oldSet.subtracting(newSet)
            newSet.subtract(oldSet)
            
            var needRemove: [Int] = []
            coordinateList.enumerated().forEach { index, coord in
                if filteredOld.contains(coord) {
                    needRemove.append(index)
                    markerList[index].mapView = nil
                    let line = polyline?.line
                    polyline?.line.removePoint(coord)
                    polyline?.line = line!
                }
            }
            
            if needRemove.isEmpty {
                isDeleted = false
            } else {
                let removeSet = IndexSet(needRemove)
                markerList.remove(atOffsets: removeSet)
                coordinateList.remove(atOffsets: removeSet)
                isDeleted = true
            }
            
            print("삭제할 인덱스:", needRemove)
            print("삭제후 마커 목록:", markerList)
            print("삭제후 좌표 목록:", coordinateList)
            print("삭제후 폴리라인 목록:", polyline?.line)
            
            newCoordList.enumerated().forEach { index, coord in
        
                if newSet.contains(coord) {
                    let iconImage = OverlayImage.allCases[index % 8].image
                    let marker = NMFMarker(position: coord, iconImage: iconImage)
                    markerList.append(marker)
                    coordinateList.append(coord)
                    let line = polyline?.line
                    polyline?.line.addPoint(coord)
                    polyline?.line = line!
                }
                
            }
            print("추가할 인덱스:", newSet)
            print("추가 후 마커 목록:", markerList)
            print("추가 후 좌표 목록:", coordinateList)
            print("추가 후 폴리라인 목록:", polyline?.line)
            
        }
        
        func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
            print("카메라 변경 - reason: \(reason)")
            
        }

        func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
            print("카메라 변경 - reason: \(reason)")
        }
        
    }

}
