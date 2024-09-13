//
//  Carousel.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

public struct InfinityCarouselView<Data: Identifiable, Content: View>: View {
    
    private let data: [Data]
    private let edgeSpacing: CGFloat
    private let contentSpacing: CGFloat
    private let totalSpacing: CGFloat
    private let contentHeight: CGFloat
    private let carouselContent: (Data) -> Content
    private let zeroContent: () -> Content
    private let overContent: () -> Content
    
    @State private var currentIndex: CGFloat = 1
    @State private var currentOffset: CGFloat = -315
    
    public init(
        data: [Data],
        edgeSpacing: CGFloat,
        contentSpacing: CGFloat,
        totalSpacing: CGFloat,
        contentHeight: CGFloat,
        @ViewBuilder carouselContent: @escaping (Data) -> Content,
        @ViewBuilder zeroContent: @escaping () -> Content,
        @ViewBuilder overContent: @escaping () -> Content
    ) {
        self.data = data
        self.edgeSpacing = edgeSpacing
        self.contentSpacing = contentSpacing
        self.totalSpacing = totalSpacing
        self.contentHeight = contentHeight
        self.carouselContent = carouselContent
        self.zeroContent = zeroContent
        self.overContent = overContent
    }
    
    public var body: some View {
        VStack {
            GeometryReader { geometry in
                let baseOffset = contentSpacing + edgeSpacing - totalSpacing
                let total: CGFloat = geometry.size.width + totalSpacing * 2
                let contentWidth = total - (edgeSpacing * 2) - (2 * contentSpacing)
                let nextOffset = contentWidth + contentSpacing
                HStack(spacing: contentSpacing) {
                    configContentView(contentView: zeroContent(),
                                      contentWidth: contentWidth,
                                      nextOffset: nextOffset)
                    ForEach(0..<data.count, id: \.self) { index in
                        configContentView(contentView: carouselContent(data[index]),
                                          contentWidth: contentWidth,
                                          nextOffset: nextOffset)
                    }
                    configContentView(contentView: overContent(),
                                      contentWidth: contentWidth,
                                      nextOffset: nextOffset)
                }
                .offset(x: currentOffset + (currentIndex > 0 ? baseOffset : 0))
            }
        }
       .padding(.horizontal, totalSpacing)
    }
    
    private func configContentView(contentView: Content, contentWidth: CGFloat, nextOffset: CGFloat) -> some View {
        contentView
        .frame(width: contentWidth, height: contentHeight)
        .gesture(
            DragGesture()
                .onEnded { value in
                    let offsetX = value.translation.width
                    if offsetX < -50 { // 오른쪽으로 스와이프
                        currentIndex = min(currentIndex + 1, CGFloat(data.count)+1)
                    } else if offsetX > 50 { // 왼쪽으로 스와이프
                        currentIndex = max(currentIndex - 1, 0)
                    }
                    withAnimation {
                        currentOffset = -currentIndex * nextOffset
                    }
                    // infintyScroll
                    if currentIndex > CGFloat(data.count) {
                        currentOffset = -1 * nextOffset
                        currentIndex = 1
                        return
                    }
                    if currentIndex < 1 {
                        currentOffset = -CGFloat(data.count) * nextOffset
                        currentIndex = CGFloat(data.count)
                        return
                    }
                }
        )
    }
}
