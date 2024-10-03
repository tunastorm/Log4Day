//
//  ImageDownSampler.swift
//  Log4Day
//
//  Created by 유철원 on 10/3/24.
//

import ImageIO
import UIKit

extension UIImage {
    
//    func downSample(scale: CGFloat) -> UIImage {
//        let data = self.pngData()! as CFData
//        let imageSource = CGImageSourceCreateWithData(data, nil)!
//        let maxPixel = max(self.size.width, self.size.height) * scale
//        let options = [
//            kCGImageSourceThumbnailMaxPixelSize: maxPixel,
//            kCGImageSourceCreateThumbnailFromImageAlways: true
//        ] as CFDictionary
//
//        let scaledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options)!
//
//        return UIImage(cgImage: scaledImage)
//    }
//    
    
    func resize(to size: CGSize) -> UIImage? {
           let options: [CFString: Any] = [
               kCGImageSourceShouldCache: false,
               kCGImageSourceCreateThumbnailFromImageAlways: true,
               kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
               kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height),
               kCGImageSourceCreateThumbnailWithTransform: true
           ]
           
           guard
               let data = pngData(),
               let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
               let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)
           else { return nil }
           
           let resizedImage = UIImage(cgImage: cgImage)
           return resizedImage
    }
    
}

