//
//  Carousel.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI
import RealmSwift

struct InfinityCarouselView<Data: Object, Content: View>: View {
    
    @EnvironmentObject var viewModel: MyLogViewModel
    
    private let data: Results<Data>
    private let edgeSpacing: CGFloat
    private let contentSpacing: CGFloat
    private let totalSpacing: CGFloat
    private let contentHeight: CGFloat
    private let carouselContent: (Data, CGFloat, Binding<CGFloat>, CGFloat) -> Content
    private let zeroContent: (CGFloat, Binding<CGFloat>, CGFloat) -> Content
    private let overContent: (CGFloat, Binding<CGFloat>, CGFloat) -> Content
    
    @State private var currentOffset: CGFloat = 0
    @State private var currentIndex: CGFloat = 1
    @State var isDragging: Bool = false
   
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
        return VStack {
            GeometryReader { geometry in
                let lastCell = CGFloat(data.count)
                let baseOffset = contentSpacing + edgeSpacing - totalSpacing
                let total: CGFloat = geometry.size.width + totalSpacing * 2
                let contentWidth = total - (edgeSpacing * 2) - (2 * contentSpacing)
                let nextOffset = contentWidth + contentSpacing
               
                if data.count <= 1 {
                    HStack(alignment: .center) {
                        Spacer()
                        if data.isEmpty {
                            configContentView(contentView: zeroContent(1,$currentIndex, lastCell),
                                              contentWidth: contentWidth,
                                              nextOffset: nextOffset, index: 0)
                        } else {
                            let view = carouselContent(data[0], 1, $currentIndex, lastCell)
                            configContentView(contentView: view,
                                              contentWidth: contentWidth,
                                              nextOffset: nextOffset, index: CGFloat(0))
                        }
                        Spacer()
                    }
                } else {
                    HStack(spacing: contentSpacing) {
                        configContentView(contentView: zeroContent(0,$currentIndex, lastCell),
                                          contentWidth: contentWidth,
                                          nextOffset: nextOffset, index: 0)
                       
                        ForEach(0..<data.count, id: \.self) { index in
                            let view = carouselContent(data[index], CGFloat(index+1), $currentIndex, lastCell)
                            configContentView(contentView: view,
                                              contentWidth: contentWidth,
                                              nextOffset: nextOffset, index: CGFloat(index + 1))
                        }
                        configContentView(contentView: overContent(lastCell + 1, $currentIndex, lastCell),
                                          contentWidth: contentWidth,
                                          nextOffset: nextOffset, index: CGFloat(lastCell + 1))
                    }
                    .offset(x: currentOffset + (currentIndex > 0 ? baseOffset : 0))
                }
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
                    guard isDragging == false,
                          viewModel.output.logList.count > 1 else {
                        return
                    }
                    isDragging = true
               
                    let offsetX = value.translation.width
                    withAnimation(.easeIn(duration: 0.1)) {
                        if offsetX < -50 { // 오른쪽으로 스와이프
                            currentIndex = min(currentIndex + 1, CGFloat(data.count)+1)
                        } else if offsetX > 50 { // 왼쪽으로 스와이프
                            currentIndex = max(currentIndex - 1, 0)
                        }
                        currentOffset = -currentIndex * nextOffset
                    }
                    // infinty Scroll
                    if currentIndex > CGFloat(data.count) {
                        currentOffset = -1 * nextOffset
                    } else if currentIndex < 1 {
                        currentOffset = -CGFloat(data.count) * nextOffset
                    }
                    withAnimation(.easeIn(duration: 0.1))  {
                        if currentIndex < 1 {
                            currentIndex = CGFloat(data.count)
                        } else if currentIndex > CGFloat(data.count) {
                            currentIndex = 1
                        }
                    }
                    fetchLogDate()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isDragging = false
                    }
                }
        )
        .onPress {
            let width = UIScreen.main.bounds.width * 0.9
            let height = UIScreen.main.bounds.height * 0.9
            let controller = UIHostingController(rootView: contentView.background(.white))
            controller.view.frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
            controller.view.backgroundColor = .clear

            if let rootVC = UIApplication.shared.windows.first?.rootViewController {
                rootVC.view.insertSubview(controller.view, at: 0)
//                rootVC.view.backgroundColor = .systemGray

                let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))

                let fourCutImage = renderer.image { context in
                    controller.view.layer.render(in: context.cgContext)
                }
                
                controller.view.removeFromSuperview()
                viewModel.action(.fourCutCellPressed(image: fourCutImage))
            }
        }
    }
    
    private func fetchLogDate() {
        guard let nowLog = data[Int(currentIndex-1)] as? Log else {
            return
        }
        viewModel.input.nowLogDate = DateFormatManager.shared.dateToFormattedString(date: nowLog.startDate, format: .dotSeparatedyyyyMMddDay)
        viewModel.action(.fetchLogDate(isInitial: false))
    }
    
}
