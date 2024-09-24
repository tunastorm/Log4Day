//
//  FSCalanderView.swift
//  Log4Day
//
//  Created by 유철원 on 9/21/24.
//
import FSCalendar
import SwiftUI
import UIKit

struct FSCalendarView: UIViewRepresentable {
    
    @Binding var selectedDate: Date
//    @Binding var dictionaryOfDateWithImage: [Date: ImageResource]
    
    @Binding var showSheet: Bool
    
    func makeCoordinator() -> Coordinator {
//        Coordinator(self, dateWithImageResourceDict: dictionaryOfDateWithImage)
        Coordinator(self)
    }

    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        calendar.locale = .current
        calendar.appearance.headerTitleColor = .systemMint
        calendar.appearance.selectionColor = .systemMint
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.weekdayFont = .boldSystemFont(ofSize: 14)
        calendar.appearance.titleWeekendColor = .systemRed
        calendar.appearance.todayColor = .black
        calendar.appearance.headerDateFormat = "yyyy.MM"
        calendar.appearance.headerTitleFont = .boldSystemFont(ofSize: 20)
        calendar.appearance.eventDefaultColor = .systemMint
        calendar.appearance.eventSelectionColor = .systemMint
        
        // Remove today circle
//        calendar.today = nil
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        // update the calendar view if necessary
//        context.coordinator.dateWithImageResourceDict = dictionaryOfDateWithImage
        uiView.reloadData()
    }

    // MARK: - Coordinator

    class Coordinator: NSObject, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
        var parent: FSCalendarView

        private lazy var dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.locale = .current
            df.dateFormat = "yyyy.MM"
            return df
        }()

        init(_ calender: FSCalendarView) {
            self.parent = calender
        }

        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
            parent.showSheet = true
        }
        
        // 날짜 선택 해제 콜백 메소드
        public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
            print(dateFormatter.string(from: date) + " 날짜가 선택 해제 되었습니다.")
        }
        
        // Need reload to have fill colors display correctly after calendar page changes
        func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
            calendar.reloadData()
        }
        
        func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
            return nil
        }
        
    }
}
