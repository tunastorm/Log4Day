//
//  HorizontalCalendarView.swift
//  Log4Day
//
//  Created by 유철원 on 9/30/24.
//

import SwiftUI
import SwiftUIX

struct HorizontalCalendarView: View {
    
    @ObservedObject var viewModel: LogMapViewModel
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(alignment: .center) {
            monthView
            ZStack {
                VStack {
                    Spacer()
                    Rectangle()
                        .frame(height: 2)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
                        .opacity(0.5)
                }
                dayView
                blurView
            }
            .frame(height: 30)
            .padding(.horizontal, 10)
        }
        .frame(maxHeight: 90)
        .background(.white)
    }
    
    // MARK: - 월 표시 뷰
    private var monthView: some View {
        HStack(spacing: 30) {
            Button(
                action: {
                    changeMonth(-1)
                },
                label: {
                    Image(systemName: "chevron.left")
                        .padding()
                }
            )
            
            Text(monthTitle(from: viewModel.output.selectedDate))
                .font(.title)
            
            Button(
                action: {
                    changeMonth(1)
                },
                label: {
                    Image(systemName: "chevron.right")
                        .padding()
                }
            )
        }
        .frame(height: 40)
        .padding(.bottom, 4)
    }
    
    // MARK: - 일자 표시 뷰
    @ViewBuilder
    private var dayView: some View {
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: viewModel.output.selectedDate))!
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                let components = (
                    0..<calendar.range(of: .day, in: .month, for: startDate)!.count)
                    .map {
                        calendar.date(byAdding: .day, value: $0, to: startDate)!
                    }
                
                ForEach(components, id: \.self) { date in
                    ZStack {
                        VStack {
                            Spacer()
                            Rectangle()
                                .frame(height: 2)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(calendar.isDate(viewModel.output.selectedDate, equalTo: date, toGranularity: .day) ? ColorManager.shared.ciColor.highlightColor : Color.clear)
                        }
                        VStack {
                            Text(day(from: date))
                                .font(.caption)
                                .foregroundStyle(day(from: date) == "일" || day(from: date) == "토" ? ColorManager.shared.ciColor.highlightColor : .gray)
                            Text("\(calendar.component(.day, from: date))")
                        }
                        .frame(width: 30, height: 33)
                        .padding(.bottom, 5)
                        .padding(.horizontal, 5)
                        .background(.clear)
                        .foregroundColor(calendar.isDate(viewModel.output.selectedDate, equalTo: date, toGranularity: .day) ? ColorManager.shared.ciColor.highlightColor : .black)
                        .onTapGesture {
                            withAnimation {
                                viewModel.action(.selectDate(date: date))
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - 블러 뷰
    private var blurView: some View {
        HStack {
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color.white.opacity(1),
                        Color.white.opacity(0)
                    ]
                ),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: 20)
            .edgesIgnoringSafeArea(.leading)
            
            Spacer()
            
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color.white.opacity(1),
                        Color.white.opacity(0)
                    ]
                ),
                startPoint: .trailing,
                endPoint: .leading
            )
            .frame(width: 20)
            .edgesIgnoringSafeArea(.leading)
        }
    }
}

// MARK: - 로직
private extension HorizontalCalendarView {
    /// 월 표시
    func monthTitle(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy MMMM")
        return dateFormatter.string(from: date)
    }
    
    /// 월 변경
    func changeMonth(_ value: Int) {
        guard let date = calendar.date(
            byAdding: .month,
            value: value,
            to: viewModel.output.selectedDate
        ) else {
            return
        }
        viewModel.action(.selectDate(date: date))
    }
    
    /// 요일 추출
    func day(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("E")
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    
}
