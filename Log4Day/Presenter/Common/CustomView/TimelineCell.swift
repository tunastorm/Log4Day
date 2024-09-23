//
//  NumberingView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

struct TimelineCell: View {
    
    @EnvironmentObject var viewModel: CategoryViewModel
    
    var index: Int
    var log: Log
    
    var body: some View {
        print("count:", viewModel.output.timeline.count)
        print("index: ",index)
        print("title:", log.title)
        
        return VStack {
            if index < viewModel.output.timeline.count &&
             (index == 0 || (index >= 1 && !DateFormatManager.shared.isSameDay(lDate: log.startDate,
                                                                  rDate: viewModel.output.timeline[index-1].startDate))) {
                dateView()
            }
            HStack {
                numberingView()
                Spacer()
                contentsView()
            }
            if  index < viewModel.output.timeline.count &&
                (index == viewModel.output.timeline.count-1 ||
                (index >= 0 && !DateFormatManager.shared.isSameDay(lDate: log.startDate,
                                                    rDate: viewModel.output.timeline[index+1].startDate))){
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Resource.ciColor.subContentColor)
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
                    .foregroundStyle(Resource.ciColor.subContentColor)
                Text(DateFormatManager.shared.dateToFormattedString(date: log.startDate, format: .dotSeparatedyyyyMMddDay))
                    .font(.callout)
                    .foregroundStyle(Resource.ciColor.contentColor)
            }
            Rectangle()
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .foregroundStyle(Resource.ciColor.subContentColor)
        }
    }
    
    private func numberingView() -> some View {
        Text("\(index+1)")
            .foregroundStyle(.white)
            .frame(width: 40, height: 40)
            .background(log.fourCut.isEmpty ? Resource.ciColor.subContentColor :  Resource.ciColor.highlightColor )
            .clipShape(Circle())
    }
    
    private func contentsView() -> some View {
        VStack {
            Spacer()
            VStack {
                HStack {
                    Text(log.title)
                        .font(.title3)
                        .bold()
                        .foregroundStyle(Resource.ciColor.contentColor)
                    Spacer()
                }
                HStack {
                    Text("#\(log.places.compactMap{ $0.hashtag }.joined(separator:" #"))")
                        .font(.caption)
                        .foregroundStyle(Resource.ciColor.subContentColor)
                    Spacer()
                }
            }
            .padding(.vertical)
            if index + 1 < viewModel.output.timeline.count &&
                             DateFormatManager.shared.isSameDay(lDate: log.startDate,
                                                                rDate: viewModel.output.timeline[index+1].startDate) {
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Resource.ciColor.subContentColor)
            }
        }
        .padding(.leading)
    }
    
}
