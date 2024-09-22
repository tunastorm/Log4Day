//
//  Carousel.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI
import RealmSwift


struct InfinityCarouselView<Data: Object, Content: View>: View {
    
    private let data: Results<Data>
    private let edgeSpacing: CGFloat
    private let contentSpacing: CGFloat
    private let totalSpacing: CGFloat
    private let contentHeight: CGFloat
    private let carouselContent: (Data, CGFloat, Binding<CGFloat>, CGFloat) -> Content
    private let zeroContent: (CGFloat, Binding<CGFloat>, CGFloat) -> Content
    private let overContent: (CGFloat, Binding<CGFloat>, CGFloat) -> Content
    @State private var currentOffset: CGFloat
    @State private var currentIndex: CGFloat = 1
   
    public init(
        data: Results<Data>,
        edgeSpacing: CGFloat,
        contentSpacing: CGFloat,
        totalSpacing: CGFloat,
        contentHeight: CGFloat,
        currentOffset: CGFloat,
        @ViewBuilder carouselContent: @escaping (Data, CGFloat, Binding<CGFloat>, CGFloat) -> Content,
        @ViewBuilder zeroContent: @escaping (CGFloat, Binding<CGFloat>, CGFloat) -> Content,
        @ViewBuilder overContent: @escaping (CGFloat, Binding<CGFloat>, CGFloat) -> Content
    ) {
        self.data = data
        self.edgeSpacing = edgeSpacing
        self.contentSpacing = contentSpacing
        self.totalSpacing = totalSpacing
        self.contentHeight = contentHeight
        self.currentOffset = currentOffset
        self.carouselContent = carouselContent
        self.zeroContent = zeroContent
        self.overContent = overContent
    }
    
    public var body: some View {
        VStack {
            GeometryReader { geometry in
                let lastCell = CGFloat(data.count)
                let baseOffset = contentSpacing + edgeSpacing - totalSpacing
                let total: CGFloat = geometry.size.width + totalSpacing * 2
                let contentWidth = total - (edgeSpacing * 2) - (2 * contentSpacing)
                let nextOffset = contentWidth + contentSpacing
                
                if data.isEmpty {
                    HStack(alignment: .center) {
                        Spacer()
                        configContentView(contentView: zeroContent(0,$currentIndex, lastCell),
                                          contentWidth: contentWidth,
                                          nextOffset: nextOffset, index: 0)
                        Spacer()
                    }
                } else {
                    HStack(spacing: contentSpacing) {
                        configContentView(contentView: zeroContent(0,$currentIndex, lastCell),
                                          contentWidth: contentWidth,
                                          nextOffset: nextOffset, index: 0)
                       
                        ForEach(0..<data.count, id: \.self) { index in
                            let view = carouselContent(data[index],CGFloat(index+1),$currentIndex, lastCell)
                            configContentView(contentView: view,
                                              contentWidth: contentWidth,
                                              nextOffset: nextOffset, index: CGFloat(index + 1))
                        }
                        
                        configContentView(contentView: overContent(CGFloat(lastCell + 1), $currentIndex, lastCell),
                                          contentWidth: contentWidth,
                                          nextOffset: nextOffset, index: CGFloat(lastCell + 1))
                    }
                    .offset(x: currentOffset + (currentIndex > 0 ? baseOffset : 0))
                }
                // LazyHStack으로 자연스러운 애니메이션 어떻게 해야하지....
               
            }
        }
       .padding(.horizontal, totalSpacing)
    }
    
    private func configContentView(contentView: Content, contentWidth: CGFloat, nextOffset: CGFloat, index: CGFloat) -> some View {
        contentView
        .frame(width: contentWidth, height: contentHeight)
        .gesture(
            DragGesture()
                .onEnded { value in
                    let offsetX = value.translation.width
                    withAnimation {
                        if offsetX < -50 { // 오른쪽으로 스와이프
                            currentIndex = min(currentIndex + 1, CGFloat(data.count)+1)
                        } else if offsetX > 50 { // 왼쪽으로 스와이프
                            currentIndex = max(currentIndex - 1, 0)
                        }
                        currentOffset = -currentIndex * nextOffset
                    }
                    if currentIndex > CGFloat(data.count) {
                        currentOffset = -1 * nextOffset
//                        withAnimation {
//                            currentIndex = 1
//                        }
//                        return
                    } else if currentIndex < 1 {
                        currentOffset = -CGFloat(data.count) * nextOffset
//                        withAnimation {
//                            currentIndex = CGFloat(data.count)
//                        }
//                        return
                    }
                    // infinty Scroll
                    withAnimation{
                        if currentIndex < 1 {
                            currentIndex = CGFloat(data.count)
                        } else if currentIndex > CGFloat(data.count) {
                            currentIndex = 1
                        }
                    }
                }
        )
    }
}
