//
//  NumberingView.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

struct LoglineCell: View {
    
    var index: Int
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("2024.09.0\(index) / 금")
                    .foregroundStyle(.mint)
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
            .background(.mint)
            .clipShape(Circle())
    }
    
    private func contentsView() -> some View {
        VStack {
            Rectangle()
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.gray.opacity(0.5))
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
                    Spacer()
                }
            }
            .padding(.vertical)
            Rectangle()
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.gray.opacity(0.5))
           
        }
        .padding(.leading)
    }
    
}
