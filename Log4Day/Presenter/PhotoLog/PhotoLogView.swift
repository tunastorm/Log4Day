//
//  PhotoLogView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

struct PhotoLogView: View {
        
    var body: some View {
        NavigationWrapper {
            ScrollView {
                Text("테스트")
            }
            .navigationTitle("PhotoLog")
        }
    }
    
}

#Preview {
    PhotoLogView()
}
