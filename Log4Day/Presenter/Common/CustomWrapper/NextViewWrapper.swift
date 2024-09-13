//
//  ExtrectionViewWrapper.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

struct NextViewWrapper<Content: View>: View {
    
    typealias InitContent = () -> Content
    
    let view: InitContent
    
    var body: some View {
        view()
    }
    
    init(_ view: @autoclosure @escaping InitContent) {
        self.view = view
        print("init - ", self)
    }
    
}
