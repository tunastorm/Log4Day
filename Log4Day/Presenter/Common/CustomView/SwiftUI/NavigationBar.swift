//
//  NavigationBar.swift
//  Log4Day
//
//  Created by 유철원 on 9/20/24.
//

import SwiftUI

struct NavigationBar<CustomButton: View>: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var normalColor: Color {
        colorScheme == .dark ? .white.opacity(0.75) : .black
    }
    
    var title: String
    
    var button: CustomButton?
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .frame(width: 80, height: 40)
                    .font(.headline)
                    .foregroundStyle(Resource.CIColor.highlightColor)
                    .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 0))
                Spacer()
                if let button {
                    button
                        .foregroundStyle(.black)
                        .buttonStyle(IsPressedButtonStyle(normalColor: normalColor, pressedColor: .gray))
                }
                SettingButton()
                    .padding(.trailing)
            }
            .frame(width: UIScreen.main.bounds.width)
        }
    }
}
