//
//  Resource.swift
//  Log4Day
//
//  Created by 유철원 on 9/14/24.
//

import SwiftUI


final class ColorManager {
    
    static let shared = ColorManager()
    
    private init() { }
    
    var ciColor = CIColor(colorScheme: .light)
    
    struct CIColor {
        
        var colorScheme: ColorScheme
        
        let highlightColor = Color.mint.opacity(0.75)
        public var backgroundColor: Color {
            colorScheme == .dark ? .black : .white
        }
        public var topUnderlineColor: Color {
            colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5)
        }
        public var contentColor: Color {
            colorScheme == .dark ? .white : .black
        }
        public var subContentColor: Color {
            colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.25)
        }
        
    }
    
    func updateColorScheme(_ colorScheme: ColorScheme) {
        ciColor = CIColor(colorScheme: colorScheme)
    }
    
}


