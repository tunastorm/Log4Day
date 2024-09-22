//
//  Resource.swift
//  Log4Day
//
//  Created by 유철원 on 9/14/24.
//

import SwiftUI


enum Resource {
    
    static let todayComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    
    static let ciColor = CIColor()

}

struct CIColor {
    @Environment(\.colorScheme) var colorScheme
    let highlightColor = Color.mint.opacity(0.75)
    var topUnderlineColor: Color {
        colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5)
    }
    var contentColor: Color {
        colorScheme == .dark ? .white : .black
    }
    var subContentColor: Color {
        colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.25)
    }
}
