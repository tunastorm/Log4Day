//
//  PHPickerView.swift
//  Log4Day
//
//  Created by 유철원 on 9/26/24.
//

import SwiftUI
import UIKit
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {

    @ObservedObject var viewModel: LogDetailViewModel
    
    @Binding var isPresented: Bool
    
    var configuration: PHPickerConfiguration
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, viewModel)
    }
 

    // Use a Coordinator to act as your PHPickerViewControllerDelegate
    class Coordinator: PHPickerViewControllerDelegate {
        
        @ObservedObject var viewModel: LogDetailViewModel
        
        private let parent: PhotoPicker

        // Identifier와 PHPickerResult로 만든 Dictionary (이미지 데이터를 저장하기 위해 만들어 줌)
        private var selections = [String : PHPickerResult]()
        
        // 선택한 사진의 순서에 맞게 Identifier들을 배열로 저장해줄 겁니다.
        // selections은 딕셔너리이기 때문에 순서가 없습니다. 그래서 따로 식별자를 담을 배열 생성
        private var selectedAssetIdentifiers = [String]()
        
        private var imageList: [UIImage] = [] {
            didSet {
                
            }
        }
        
        init(_ parent: PhotoPicker, _ viewModel: LogDetailViewModel) {
            self.parent = parent
            self.viewModel = viewModel
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

            parent.isPresented = false
        
            let group = DispatchGroup()
            results.forEach {
                $0.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                    if let image = object as? UIImage {
                        group.enter()
                        DispatchQueue.main.async(group: group) {
                            self?.imageList.append(image)
                            
                            if let imageList = self?.imageList, imageList.count == results.count {
                                self?.viewModel.input.pickedImages = imageList
                                self?.viewModel.action(.photoPicked)
                            }
                            group.leave()
                        }
                    }
                }
            }
           
        }
        
    }
    
}
