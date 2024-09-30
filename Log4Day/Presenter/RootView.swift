//
//  ContentView.swift
//  Log4Day
//
//  Created by 유철원 on 9/10/24.
//

import SwiftUI

struct RootView: View {
        
    @State private var selection = 0
    @ObservedObject var categoryViewModel = CategoryViewModel()
    
    init() {
        let navBarAppearance = UINavigationBarAppearance()
        // 객체 생성
        navBarAppearance.backgroundColor = .white
        navBarAppearance.shadowColor = .clear
        // 객체 속성 변경
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .white
        tabBarAppearance.shadowColor = .systemGray6
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    var body: some View {
        NavigationWrapper(button: Text("")) {
            TabView(selection: $selection) {
                MyLogView(categoryViewModel: categoryViewModel)
                    .tabItem {
                        Image(systemName: selection == 0 ?
                              "photo.on.rectangle.angled" : "photo.on.rectangle")
                            .renderingMode(.template)
                        Text("MyLog")
                    }
                    .tag(0)
                NewLogView(categoryViewModel: categoryViewModel)
                    .tabItem {
                        Image(systemName: selection == 1 ?
                             "pencil.line" : "plus.app")
                            .renderingMode(.template)
                        Text("New")
                    }
                    .tag(1)
//                LogMapView(categoryViewModel: categoryViewModel)
//                    .tabItem {
//                        Image(systemName:  selection == 2 ?
//                              "mappin.and.ellipse" : "map")
//                            .renderingMode(.template)
//                        Text("LogMap")
//                    }
//                    .tag(2)
            }
            .font(.headline)
            .tint(ColorManager.shared.ciColor.highlightColor)
        }

    }
}

#Preview {
    RootView()
}
