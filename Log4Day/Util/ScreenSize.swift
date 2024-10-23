//
//  ScreenSize.swift
//  Log4Day
//
//  Created by 유철원 on 10/22/24.
//

import UIKit

enum ScreenSize {
    static var width: CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.screen.bounds.size.width
        }
        return UIScreen.main.bounds.size.width
    }
    static var height: CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.screen.bounds.size.height
        }
        return UIScreen.main.bounds.size.height
    }
}
