//
//  MenuButton.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

struct SettingButton: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var normalColor: Color {
        colorScheme == .dark ? .white.opacity(0.75) : .black
    }
    
    struct SettingElement: Hashable, Identifiable {
        
        let id = UUID()
        let name: String
        let image: String
        let action: () -> Void
        
        static func == (lhs: SettingElement, rhs: SettingElement) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.id)
        }
        
    }
    
    private var settingElements: [SettingElement] {
        [
            SettingElement(name: "\(colorScheme == .dark ? "라이트" : "다크")모드", image: "circle.lefthalf.filled", action: changeColorScheme),
            SettingElement(name: "데이터 초기화", image: "minus.circle", action: resetData)
        ]
    }
    
    @State private var elementShowingList: [Bool] = []
    
    var body: some View {
        let settingCount = settingElements.count
        (0..<settingCount).forEach { _ in elementShowingList.append(false) }

        return Menu {
            ForEach(settingElements.indices, id: \.self) { index in
                let item = settingElements[index]
                if index < settingElements.count - 1 {
                    Button {
                        item.action()
                    } label: {
                        Label(.init(item.name), systemImage: item.image)
                    }
                } else {
                    Button(role: .destructive) {
                        item.action()
                    } label: {
                        Label(.init(item.name), systemImage: item.image)
                    }
                }
            }
        } label: {
            Image(systemName: "line.3.horizontal")
        }
        .foregroundStyle(normalColor)
        
//        ToolbarItem(id: "setting", placement: .topBarTrailing) {
//            Menu {
//                ForEach(settingElements.indices, id: \.self) { index in
//                    let item = settingElements[index]
//                    if index < settingElements.count - 1 {
//                        Button {
//                            item.action()
//                        } label: {
//                            Label(.init(item.name), systemImage: item.image)
//                        }
//                    } else {
//                        Button(role: .destructive) {
//                            item.action()
//                        } label: {
//                            Label(.init(item.name), systemImage: item.image)
//                        }
//                    }
//                }
//            } label: {
//                Image(systemName: "line.3.horizontal")
//            }
//            .foregroundStyle(normalColor)
//         
//        }
        
     }
    
    private func changeColorScheme() {
        print("컬러모드: ", colorScheme)
    }
    
    private func resetData() {
        print("데이터 초기화!!!")
    }
}
