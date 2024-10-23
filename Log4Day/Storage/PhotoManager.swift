//
//  ResourceManager.swift
//  Log4Day
//
//  Created by 유철원 on 9/21/24.
//

import UIKit

final class PhotoManager: FileManager {
    
    static let shared = PhotoManager()
    
    private var documentDirectory: URL?

    override init() {
        self.documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first
    }
    
    func saveImageToDocument(image: UIImage, filename: String) {
        // document 위치 할당
        guard let documentDirectory else { return }
        
        //이미지를 저장할 경로(파일명) 지정
        let fileURL = documentDirectory.appendingPathComponent("\(filename).png")
        
        //이미지를 data로 변환
        guard let data = image.pngData() else { return }
        
        //이미지 파일 저장
        do {
            try data.write(to: fileURL)
        } catch {
//            print("file save error", error)
        }
    }
    
    func loadImageFromDocument(filename: String) -> UIImage? {
        guard let documentDirectory else {
            return nil
        }
        let path = documentDirectory.appendingPathComponent("\(filename).png").path
        let fileURL = NSURL(fileURLWithPath: path)
        guard let path = fileURL.path else {
            return nil
        }
        // 이미지 다운샘플링 옵션
        let options: [CFString: Any] = [
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceThumbnailMaxPixelSize: max(((ScreenSize.width - 10) / 2) - 10,
                                                    (ScreenSize.height / 2) - 10 ),
            kCGImageSourceCreateThumbnailWithTransform: true
        ]
        //이 경로에 실제로 파일이 존재하는 지 확인
        if FileManager.default.fileExists(atPath: path),
            let imageSource = CGImageSourceCreateWithURL(fileURL, nil),
            let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) {
            return UIImage(cgImage: cgImage)
        } else {
            return UIImage(systemName: "star.fill")
        }
    }
    

    func removeImageFromDocument(filename: String) -> Bool? {
        guard let documentDirectory else { return nil }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).png")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                return true
            } catch {
                print(#function, "file remove error", error)
                return false
            }
        } else {
            return nil
        }
    }
}
