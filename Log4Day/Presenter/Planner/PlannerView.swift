//
//  PlannerView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI
import RealmSwift

struct PlannerView: View {
    
    @ObservedResults(Log.self) var logList
    
    @State private var date = Date()
    
    @State private var showSide = false
    
    @State private var showSheet = false
    
    @State private var selectedCategory = "전체"
   
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
                                .font(.system(size: 20))
                        })
                    )
                    ScrollView {
                        CalenderView(month: date, logList: $logList)
                    }
                   
                }
                SideBarView()
            }
        }
        .padding(.bottom, 130)
        .task {
            await queryWithCategory()
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
//                TimelineCell(index: index)
            }
        }
        .background(.clear)
        .frame(maxWidth: .infinity)
        .padding()
   }
    
    private func queryWithCategory() async {
        if selectedCategory == "전체" {
            return
        }
        $logList.filter = Log.Column.owner.query(search: selectedCategory, condition: .equals)
    }
    
}

#Preview {
    PlannerView()
}
