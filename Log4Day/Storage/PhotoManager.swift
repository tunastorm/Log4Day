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
        
        //이미지 압축
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        //이미지 파일 저장
        do {
            try data.write(to: fileURL)
        } catch {
//            print("file save error", error)
        }
    }
    
    func loadImageFromDocument(filename: String) -> UIImage? {
        guard let documentDirectory
              /*let path = Bundle.main.path(forResource: filename, ofType: "png")*/ else {
            return nil
        }
        let path = documentDirectory.appendingPathComponent("\(filename).png").path
        let fileURL = NSURL(fileURLWithPath: path)
        guard let path = fileURL.path else {
            return nil
        }
        
//        let fileURL = documentDirectory.appendingPathComponent("\(filename).png")
        
        //이 경로에 실제로 파일이 존재하는 지 확인
        let options: [CFString: Any] = [
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceThumbnailMaxPixelSize: max(((UIScreen.main.bounds.width - 10) / 2) - 10,
                                                    (UIScreen.main.bounds.height / 2) - 10 ),
            kCGImageSourceCreateThumbnailWithTransform: true
        ]
        
        if FileManager.default.fileExists(atPath: path), 
            let imageSource = CGImageSourceCreateWithURL(fileURL, nil),
            let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) {
            return UIImage(cgImage: cgImage)
//            if #available(iOS 16.0, *) {
//                return UIImage(contentsOfFile: fileURL.path())
//            } else {
//                return UIImage(contentsOfFile: fileURL.path)
//            }
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
            print("file no exist")
        }
    }
}
