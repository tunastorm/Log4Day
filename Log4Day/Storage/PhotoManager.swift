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
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        //이미지 압축
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        //이미지 파일 저장
        do {
            try data.write(to: fileURL)
        } catch {
            print("file save error", error)
        }
    }
    
    func loadImageToDocument(filename: String) -> UIImage? {
        guard let documentDirectory else { return nil }
             
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        //이 경로에 실제로 파일이 존재하는 지 확인
    
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            if #available(iOS 16.0, *) {
                return UIImage(contentsOfFile: fileURL.path())
            } else {
                return UIImage(contentsOfFile: fileURL.path)
            }
        } else {
            return UIImage(systemName: "star.fill")
        }
    }
    

    func removeImageFromDocument(filename: String) -> Bool? {
        guard let documentDirectory else { return nil }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
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
