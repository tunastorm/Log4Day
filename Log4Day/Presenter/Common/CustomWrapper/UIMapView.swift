//
//  NaverMapRepresentable.swift
//  Log4Day
//
//  Created by 유철원 on 9/20/24.
//

import SwiftUI
import NMapsMap

struct UIMapView: UIViewRepresentable {
    
    typealias PhotoDict = [Int : [Photo]]
    typealias ImageDict = [Int : [UIImage]]
    
    @Binding var cameraPointer: Int
    @Binding var placeList: [Place]
    @Binding var imageDict: ImageDict
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
        return Coordinator()
    }

    func makeUIView(context: Context) -> NMFNaverMapView {
        let view = NMFNaverMapView()
        view.showScaleBar = true
        view.showZoomControls = false
        view.showCompass = false
        view.mapView.positionMode = .disabled
        view.mapView.locationOverlay.hidden = true
        view.mapView.zoomLevel = 12
        view.mapView.allowsScrolling = true
        view.mapView.addCameraDelegate(delegate: context.coordinator)
        return view
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        DispatchQueue.main.async() {
            //MARK: 카메라 위치 갱신
            context.coordinator.lastCameraPointer = context.coordinator.cameraPointer
            if coordinateList.isEmpty, context.coordinator.lastCameraPointer < 0 {
                context.coordinator.lastCameraPointer = 0
            }
        
            if context.coordinator.isDeleted {
                context.coordinator.cameraPointer = placeList.count - 1
                context.coordinator.isDeleted = false
            } else {
                context.coordinator.cameraPointer = cameraPointer
            }
            cameraPointer = context.coordinator.cameraPointer
            
            //MARK: 오버레이 요소 갱신
            context.coordinator.exchangeOverlays(coordinateList, imageDict, touchHandler: changeCameraPointer)
            
            guard context.coordinator.coordinateList.count > 0 else {
                return
            }
            
            //MARK: 마커에 맵뷰 할당
            context.coordinator.markerList.forEach { $0.mapView = uiView.mapView }
            
            //MARK: 마커 간의 직선 갱신
            if let polyline = context.coordinator.polyline, polyline.line.points.count > 1 {
                polyline.mapView = uiView.mapView
            } else if let newline = NMFPolylineOverlay(coordinateList) {
                newline.width = 4
                newline.color = .systemGray2
                newline.pattern = [10,6]
                newline.joinType = .round
                newline .mapView = uiView.mapView
                context.coordinator.polyline = newline
            }
            
            //MARK: 카메라 이동 애니메이션
            if placeList.count > 0 {
                var pointer = cameraPointer == context.coordinator.cameraPointer ?
                    cameraPointer : context.coordinator.cameraPointer
            
                if pointer >= placeList.count {
                    pointer = placeList.count - 1
                } else if pointer < 0 {
                    pointer = 0
                }

                let nmgLatlng = NMGLatLng(lat: placeList[pointer].latitude,
                                          lng: placeList[pointer].longitude)
                
                let cameraUpdate = NMFCameraUpdate(scrollTo: nmgLatlng)
                cameraUpdate.animation = .easeIn
                cameraUpdate.animationDuration = 1
                uiView.mapView.moveCamera(cameraUpdate)
            }
        }
        
    }

    private func changeCameraPointer(new: Int) {
        cameraPointer = new
    }
    
    class Coordinator: NSObject, NMFMapViewCameraDelegate {
        
        var isDeleted: Bool = false
        var cameraPointer: Int = 0
        var lastCameraPointer: Int = 0
        var markerList: [NMFMarker] = []
        var coordinateList: [NMGLatLng] = []
        var polyline: NMFPolylineOverlay?
        var imageDict: [Int:[UIImage]] = [:]
        var photoDict: [Int:[Photo]]?
        
        // 1. UIMapView와 Coordinator의 cooridnateList를 Set으로 비교
        // 2. 기존 오버레이 요소 중 뺄 것과 새로 추가할 오버레이를 구분해 갱신
        func exchangeOverlays(_ newCoordList: [NMGLatLng], _ newImage: ImageDict, touchHandler: @escaping (Int) -> Void) {
            
            // 장소 증감 없는 이벤트 처리
            if coordinateList.count > 0, coordinateList == newCoordList {
                exchangeImages(newImage: newImage)
                selectedMarkerToggle()
                return
            }
            
            //MARK: 제거할 요소와 추가할 요소 구분
            var oldSet = Set<NMGLatLng>()
            var newSet = Set<NMGLatLng>()
            coordinateList.forEach { oldSet.insert($0) }
            newCoordList.forEach { newSet.insert($0) }
            
            let filteredOld = oldSet.subtracting(newSet)
            newSet.subtract(oldSet)
        
            //MARK: 제거할 오버레이 요소 삭제
            var needRemove: [Int] = []
            coordinateList.enumerated().forEach { index, coord in
                if filteredOld.contains(coord) {
                    needRemove.append(index)
                    markerList[index].mapView = nil
                    let line = polyline?.line
                    line?.removePoint(coord)
                    polyline?.line = line!
                    if let count = polyline?.line.points.count, count <= 1 {
                        polyline?.mapView = nil
                    }
                    imageDict.removeValue(forKey: index)
                }
            }
            
            if needRemove.isEmpty {
                isDeleted = false
            } else {
                let removeSet = IndexSet(needRemove)
                coordinateList.remove(atOffsets: removeSet)
                markerList.remove(atOffsets: removeSet)
                markerList.enumerated().forEach { index, marker in
                    marker.iconImage = markerImage(index)
                }
                isDeleted = true
            }
            
            guard !isDeleted else { return }
            
            //MARK: 추가할 오버레이 요소 생성
            newCoordList.enumerated().forEach { index, coord in
        
                if newSet.contains(coord) {
                    addImage(index, newImage: newImage)
                    addPhoto(index, newPhoto: photoDict)
                    let iconImage = markerImage(index)
                    let marker = NMFMarker(position: coord, iconImage: iconImage)
                    let touchPointer = markerList.count
                    marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                        touchHandler(touchPointer)
                        return true
                    }
                    markerList.append(marker)
                    selectedMarkerToggle()
                    coordinateList.append(coord)
                    let line = polyline?.line
                    polyline?.line.addPoint(coord)
                    polyline?.line = line!
                }
                
            }
            
        }
        
        func exchangeImages(newImage: ImageDict) {
            imageDict[cameraPointer] = newImage[cameraPointer]
            
            guard markerList.count >= cameraPointer else {
                return
            }
            markerList[cameraPointer].iconImage = markerImage(cameraPointer)
        }
        
        func selectedMarkerToggle() {
            let markerCount = markerList.count
            if markerCount > 0, cameraPointer < markerCount {
                if cameraPointer != lastCameraPointer, lastCameraPointer >= 0, lastCameraPointer <= markerCount {
                    markerList[lastCameraPointer].iconImage = markerImage(lastCameraPointer)
                }
                markerList[cameraPointer].iconImage = markerImage(cameraPointer)
            }
        }
    
        func addImage(_ index: Int, newImage: ImageDict) {
            if !imageDict.keys.contains(index) {
                imageDict[index] = []
            }
            imageDict[index] = newImage[index]
        }
        
        func addPhoto(_ index: Int, newPhoto: PhotoDict?) {
            
            if photoDict == nil {
                photoDict = [:]
            }
            
            guard var photoDict, let newPhoto else { return }
            
            if !photoDict.keys.contains(index) {
                photoDict[index] = []
            }
            photoDict[index] = newPhoto[index]
            
        }
        
        func markerImage(_ index: Int) -> NMFOverlayImage {
            //마커 이미지 구성
            let markerView = MarkerView(isPointed: index == cameraPointer, 
                                        index: index,
                                        count: imageDict[index]?.count ?? 0,
                                        image: imageDict[index]?.first)
            
            let size = index == cameraPointer ? 119 : 109
            let controller = UIHostingController(rootView: markerView)
            controller.view.frame = CGRect(origin: .zero, size: CGSize(width: size, height: size))
            controller.view.backgroundColor = .clear

            if let rootVC = UIApplication.shared.windows.first?.rootViewController {
                rootVC.view.insertSubview(controller.view, at: 0)

                let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))

                let markerImage = renderer.image { context in
                    controller.view.layer.render(in: context.cgContext)
                }
                
                controller.view.removeFromSuperview()
                
                return NMFOverlayImage(image: markerImage)
            } else {
                return OverlayImage.allCases[index % 8].image
            }
        }
        
        func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
//            print("카메라 변경 - reason: \(reason)")
            
        }

        func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
//            print("카메라 변경 - reason: \(reason)")
        }
        
        
    }

}
