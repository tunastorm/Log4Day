//
//  SplashView.swift
//  Log4Day
//
//  Created by 유철원 on 10/1/24.
//

import SwiftUI

struct SplashView: View {
    
    var body: some View {
        
        VStack(alignment: .center) {
            Spacer()
            Image("appIcon")
                .resizable()
                .frame(width: 200, height: 200)
                .foregroundStyle(ColorManager.shared.ciColor.highlightColor)
                .background(ColorManager.shared.ciColor.highlightColor)
                .cornerRadius(20, corners: .allCorners)
            Text("Log4Day")
                .font(.title)
                .foregroundStyle(ColorManager.shared.ciColor.highlightColor)
            Spacer()
        }
      
        
    }
    
}

#Preview {
    SplashView()
}
