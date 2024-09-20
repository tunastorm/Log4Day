//
//  PlannerView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

struct PlannerView: View {
    
    @State private var date = Date()
    
    @State private var showSide = false
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack {
                    NavigationBar(title: "Planner", button:
                        Button(action: {
                            withAnimation(.spring()){
                                showSide.toggle()
                            }
                        }, label: {
                            Image(systemName: "tray")
                        })
                    )
                    ScrollView {
                        calendar()
                        
                    }
                }
                SideBarView(showSide: $showSide)
            }
        }
    }
    
    private func calendar() -> some View {
        DatePicker("로그 캘린더", selection: $date, displayedComponents: [.date])
            .datePickerStyle(.graphical)
            .padding(.horizontal)
    }
    
    private func loglineList() -> some View {
        LazyVStack {
            ForEach(0..<100) { index in
                LoglineCell(index: index)
            }
        }
        .background(.clear)
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#Preview {
    PlannerView()
}
