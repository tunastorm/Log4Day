//
//  MyLogViewModel.swift
//  Log4Day
//
//  Created by 유철원 on 9/19/24.
//

import SwiftUI
import Combine

final class PhotoBannerViewModel: ObservableObject {
    
    @Published var FourCutPhotoIndex = 0
    
    private var timer: Timer?
    
//    var setDummy = (0..<Int.random(in: 5...10)).map { index in
//        TestSchedule(title: "테스트 \(index)", hashTags: "#테스트 일정 \(index) #입니다만?")
//    }
//    
//    lazy var FourCutPhotoList: [TestSchedule] = setDummy
    
//    @State private var categoryList = [
//        "전체", "데이트", "회사", "고등학교 친구", "중학교 친구", "러닝크루"
//    ]
    
//    func correctedIndex(for index: Int) -> Int {
//        let count = FourCutPhotoList.count
//        return (count + index) % count
//    }
//    
//    func startAutoScroll() {
//        stopAutoScroll()
//        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
//            guard let self else { return }
//            self.FourCutPhotoIndex = self.correctedIndex(for: self.FourCutPhotoIndex + 1)
//        }
//    }
//    
//    func stopAutoScroll() {
//        timer?.invalidate()
//        timer = nil
//    }
    
}
