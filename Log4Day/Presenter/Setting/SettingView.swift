//
//  SettingView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//
//
//import SwiftUI
//
//struct SettingItem: Identifiable {
//    var id = UUID()
//    var title: String
//    var action: () -> Void
//}
//
//struct SettingView: View {
//    
//    @Environment(\.colorScheme) var colorScheme
//    
//    private var settingElements: [SettingItem] {
//        [
//            SettingItem(title: "\(colorScheme == .dark ? "라이트" : "다크")모드", action: {
//                ColorManager.shared.updateColorScheme(colorScheme == .dark ? .light: .dark)
//            }),
//            SettingItem(title: "데이터 초기화", action: {
//                
//            })
//        ]
//    }
//    
//    var body: some View {
//        ScrollView {
//            settingList()
//        }
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: BackButton())
//        .toolbar() {
//            ToolbarTitle(text: "설정", placement: .topBarTrailing)
//        }
//
//    }
//    
//    private func settingList() -> some View {
//        VStack {
//            ForEach(settingElements, id: \.id) { item in
//                SettingCell(item: item)
//            }
//        }
//    }
//    
//}
//
//struct SettingCell: View {
//    
//    var item: SettingItem
//    
//    var body: some View {
//        VStack {
//            HStack {
//                Button(action: {
//                    item.action()
//                }, label: {
//                    Text(item.title)
//                        .font(.title3)
//                })
//                .buttonStyle(IsPressedButtonStyle(normalColor: .black, pressedColor: ColorManager.shared.ciColor.highlightColor))
//                .padding()
//            }
//        }
//    }
//    
//}
//
//#Preview {
//    SettingView()
//}
