//
//  NumberingView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI
import RealmSwift

struct TimelineCell: View {
    
    @EnvironmentObject var viewModel: MyLogViewModel
    
    var index: Int
    var title: String
    var startDate: Date
    var fourCutCount: Int
    
    var body: some View {
        VStack {
            if index < viewModel.output.timeline.count &&
             (index == 0 || (index >= 1 && !DateFormatManager.shared.isSameDay(lDate: startDate,
                                                                  rDate: viewModel.output.timeline[index-1].startDate))) {
                dateView()
                    .padding(.top)
            }
            HStack {
                numberingView()
                Spacer()
                contentsView()
            }
            
            if  index < viewModel.output.timeline.count &&
                (index == viewModel.output.timeline.count-1 ||
                (index >= 0 && !DateFormatManager.shared.isSameDay(lDate: startDate,
                                                    rDate: viewModel.output.timeline[index+1].startDate))){
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top)
    }
    
    private func dateView() -> some View {
        VStack {
            HStack {
                Spacer()
                Text("Date: ")
                    .font(.caption)
                    .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
                Text(DateFormatManager.shared.dateToFormattedString(date: startDate, format: .dotSeparatedyyyyMMddDay))
                    .font(.callout)
                    .foregroundStyle(ColorManager.shared.ciColor.contentColor)
            }
            Rectangle()
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
        }
    }
    
    private func numberingView() -> some View {
        Text("\(index+1)")
            .foregroundStyle(.white)
            .frame(width: 40, height: 40)
            .background(fourCutCount < 4 ? ColorManager.shared.ciColor.subContentColor :  ColorManager.shared.ciColor.highlightColor )
            .clipShape(Circle())
    }
    
    private func contentsView() -> some View {
        VStack {
            VStack {
                HStack {
                    Text(title)
                        .font(.title3)
                        .bold()
                        .foregroundStyle(ColorManager.shared.ciColor.contentColor)
                    Spacer()
                }
                HStack {
//                    Text("#\(log.places.compactMap{ $0.hashtag }.joined(separator:" #"))")
                    Text("")
                        .font(.caption)
                        .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
                    Spacer()
                }
            }
            .padding(.vertical)
            if index + 1 < viewModel.output.timeline.count &&
                             DateFormatManager.shared.isSameDay(lDate: startDate,
                                                                rDate: viewModel.output.timeline[index+1].startDate) {
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(ColorManager.shared.ciColor.subContentColor)
            }
        }
        .padding(.leading)
    }
    
}
