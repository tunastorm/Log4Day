//
//  SettingView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

struct SettingView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    private var settingElements: [String] { 
        [ 
          "\(colorScheme == .dark ? "라이트" : "다크")모드",
          "데이터 초기화"
        ]
    }
    
    var body: some View {
        ScrollView {
            settingList()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
        .toolbar() {
            ToolbarTitle(text: "설정", placement: .topBarTrailing)
        }

    }
    
    private func settingList() -> some View {
        VStack {
            ForEach(settingElements, id: \.self) { item in
                SettingCell(text: item) {
                    
                }
            }
        }
    }
    
}

struct SettingCell: View {
    
    var text: String
    
    var action: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    action()
                }, label: {
                    Text(text)
                        .font(.title3)
                })
                .buttonStyle(IsPressedButtonStyle(normalColor: .black, pressedColor: Resource.ciColor.highlightColor))
                .padding()
            }
            
            
        }
    }
    
}

#Preview {
    SettingView()
}
