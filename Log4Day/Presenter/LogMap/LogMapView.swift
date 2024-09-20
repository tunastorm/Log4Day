//
//  LoglineView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

struct LogMapView: View {
    
    @State private var showSide = false
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack {
                    NavigationBar(title: "LogMap", button:
                        Button(action: {
                            withAnimation(.spring()){
                                showSide.toggle()
                            }
                        }, label: {
                            Image(systemName: "tray")
                        })
                    )
                    ScrollView {
                       UIViewControllerWrapper<MapView>()
                    }
                }
                SideBarView(showSide: $showSide)
            }
        }
    }
}



#Preview {
    LoglineView()
}
