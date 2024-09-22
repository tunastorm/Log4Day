//
//  NumberingView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

struct LoglineCell: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    var index: Int
    
    private var baseColor: Color {
        colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.25)
    }
    
    private var contentColor: Color {
        colorScheme == .dark ? .white.opacity(0.75) : .black.opacity(0.5)
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Date: ")
                    .font(.caption)
                    .foregroundStyle(baseColor)
                Text("2024.09.0\(index) / 금")
                    .font(.callout)
                    .foregroundStyle(contentColor)
            }
            HStack {
                numberingView()
                Spacer()
                contentsView()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top)
    }
    
    private func numberingView() -> some View {
        Text("\(index)")
            .foregroundStyle(.white)
            .frame(width: 40, height: 40)
            .background(index % 3 == 0 ? Resource.ciColor.highlightColor : baseColor)
            .clipShape(Circle())
    }
    
    private func contentsView() -> some View {
        VStack {
            Rectangle()
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .foregroundStyle(baseColor)
            Spacer()
            VStack {
                HStack {
                    Text("테스트 logline \(index)")
                        .font(.title3)
                        .bold()
                    Spacer()
                }
                HStack {
                    Text("#테스트 로그 \(index) #입니다만 #???")
                        .font(.caption)
                        .foregroundStyle(contentColor)
                    Spacer()
                }
            }
            .padding(.vertical)
            Rectangle()
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .foregroundStyle(baseColor)
           
        }
        .padding(.leading)
    }
    
}
