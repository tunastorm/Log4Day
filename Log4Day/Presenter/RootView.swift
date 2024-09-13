//
//  ContentView.swift
//  Log4Day
//
//  Created by 유철원 on 9/10/24.
//

import SwiftUI

struct RootView: View {
    
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            PhotoLogView()
                .tabItem {
                    Image(systemName: selection == 0 ?
                          "photo.on.rectangle.angled" : "photo.on.rectangle")
                        .renderingMode(.template)
                    Text("PhotoLog")
                }
                .tag(0)
            PlannerView()
                .tabItem {
                    Image(systemName: selection == 1 ?
                          "calendar.badge.plus" : "calendar")
                        .renderingMode(.template)
                    Text("Planner")
                }
                .tag(1)
            LoglineView()
                .tabItem {
                    Image(systemName:  selection == 2 ?
                          "mappin.and.ellipse" : "map")
                        .renderingMode(.template)
                    Text("Logline")
                }
                .tag(2)
        }
        .font(.headline)
        .tint(.mint)
    }
}

#Preview {
    RootView()
}
