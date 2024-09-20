//
//  PlannerView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

struct PlannerView: View {
    
    @State var date = Date()
    
    var body: some View {
        ScrollView {
            calendar()
        }
        .navigationTitle("Planner")
    }
    
    private func calendar() -> some View {
        DatePicker("로그 캘린더", selection: $date, displayedComponents: [.date])
            .datePickerStyle(.graphical)
            .padding(.horizontal)
    }
}

#Preview {
    PlannerView()
}
