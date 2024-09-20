//
//  InfinitePageView.swift
//  Log4Day
//
//  Created by 유철원 on 9/19/24.
//

import SwiftUI

struct InfinitePageView<C, T>: View where C: View, T: Hashable {
    
    @Binding var selection: T
    
    let before: (T) -> T
    
    let after: (T) -> T
    
    @ViewBuilder let view: (T) -> C
    
    @State private var currentTab: Int = 0
    
    var body: some View {
        let previousIndex = before(selection)
        let nextIndex = after(selection)
        
        TabView(selection: $currentTab) {
            view(previousIndex)
                .tag(-1)
            view(selection)
                .onDisappear {
                    if currentTab != 0 {
                        selection = currentTab < 0  ? previousIndex : nextIndex
                        currentTab = 0
                    }
                }
                .tag(0)
            view(nextIndex)
                .tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .disabled(currentTab != 0)
    }
}


