//
//  Carousel.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI
import RealmSwift
import SnapKit

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
            guard !data.isEmpty else {
                return
            }
            let width = UIScreen.main.bounds.width * 0.9
            let height = UIScreen.main.bounds.height * 0.9
            
            let framedController = setFourCutImageFrame(contentView)
            framedController.view.frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
            if let rootVC = UIApplication.shared.windows.first?.rootViewController {
                rootVC.view.insertSubview(framedController.view, at: 0)
                
//                print(rootVC.view.layer.frame.minX, rootVC.view.layer.frame.minY, rootVC.view.layer.frame.maxY, rootVC.view.layer.frame.maxX)
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
                
                let rawFourCutImage = renderer.image { context in
                    framedController.view.layer.render(in: context.cgContext)
                }
                
                framedController.view.removeFromSuperview()
                
                guard let fourCutImage = cropWithDate(rawFourCutImage) else {
                    return
                }
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
    
    private func setFourCutImageFrame(_ contentView: Content) -> UIHostingController<some View> {
        var date = ""
        
        if let photoView = contentView as? FourCutPictureView {
            let rawDate = photoView.photos.first?.owner.first?.startDate ?? Date()
            date = DateFormatManager.shared.dateToFormattedString(date: rawDate, format: .dotSeparatedyyyyMMddDay)
        }
        
        let edittedContentView = contentView
                                    .background(.clear)
                                    .opacity(1.5)
        
        var controller = UIHostingController(rootView: edittedContentView)
        controller.view.backgroundColor = .white
        
        let dateLabel = {
            let label = UILabel()
            label.text = "Date: "
            label.textAlignment = .left
            label.font = .systemFont(ofSize: 12)
            label.textColor = .black
            label.layer.opacity = 0.25
            return label
        }()
        
        let photoDateLabel = {
            let label = UILabel()
            label.text = date
            label.textAlignment = .left
            label.font = .systemFont(ofSize: 14)
            label.textColor = .black
            return label
        }()
        
        let lineView = {
            let view = UIView()
            view.backgroundColor = .black
            view.layer.opacity = 0.25
            return view
        }()
//        
//        let poweredByLabel = {
//            let label = UILabel()
//            label.text = "Powered By "
//            label.textAlignment = .right
////            label.font = .systemFont(ofSize: 10)
//            label.font = .systemFont(ofSize: 8)
//            label.textColor = .black
//            label.layer.opacity = 0.25
////            label.backgroundColor = .red
//            return label
//        }()
        
        let appTitleLabel = {
            let label = UILabel()
            label.text = "Log4Day"
            label.font = .boldSystemFont(ofSize: 16)
//            label.font = .boldSystemFont(ofSize: 13)
            label.textAlignment = .right
            label.textColor = .systemMint
            label.layer.opacity = 0.75
//            label.backgroundColor = .red
            return label
        }()
        
//        controller.view.addSubview(poweredByLabel)
        controller.view.addSubview(appTitleLabel)
        controller.view.addSubview(dateLabel)
        controller.view.addSubview(photoDateLabel)
        controller.view.addSubview(lineView)
    
        dateLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(40)
            make.top.equalToSuperview().offset(80)
            make.leading.equalToSuperview().inset(20)
        }
        photoDateLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(100)
            make.top.equalToSuperview().offset(80)
            make.leading.equalTo(dateLabel.snp.trailing)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        appTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(70)
            make.bottom.equalToSuperview().inset(45)
            make.trailing.equalToSuperview().inset(20)
        }
//        poweredByLabel.snp.makeConstraints { make in
//            make.height.equalTo(20)
//            make.width.equalTo(70)
//            make.bottom.equalToSuperview().inset(43)
//            make.trailing.equalTo(appTitleLabel.snp.leading).offset(-5)
//        }
        
        
//        appTitleLabel.snp.makeConstraints { make in
//            make.height.equalTo(15)
//            make.width.equalTo(60)
//            make.bottom.equalToSuperview().inset(100)
//            make.trailing.equalToSuperview().inset(30)
//        }
//        poweredByLabel.snp.makeConstraints { make in
//            make.height.equalTo(10)
//            make.width.equalTo(50)
//            make.bottom.equalToSuperview().inset(100)
//            make.trailing.equalTo(appTitleLabel.snp.leading)
//        }
        return controller
    }
    
    private func cropWithDate(_ image: UIImage) -> UIImage? {
        
        let width = UIScreen.main.bounds.width - 25
        let height = UIScreen.main.bounds.height - 170
        
        let cropArea = CGRect(x: 0, y: 60,
                              width: image.size.width ,
                              height: image.size.height)
        
        var scaledCropArea: CGRect = CGRectMake(
            cropArea.origin.x * image.scale,
            cropArea.origin.y * image.scale,
            width * image.scale,
            height * image.scale
        )
   
        guard let cgImage = image.cgImage,
              let croppedImgRef = cgImage.cropping(to: scaledCropArea) else {
            return nil
        }
        
        return UIImage(cgImage: croppedImgRef, 
                       scale: image.scale, orientation:
                        image.imageOrientation)
    }
    
    
    private func cropJustPolaroid(_ image: UIImage) -> UIImage? {
        
        let width = UIScreen.main.bounds.width - 74
        let height = UIScreen.main.bounds.height - 312
        
        let cropArea = CGRect(x: 18, y: 140,
                              width: image.size.width ,
                              height: image.size.height)
        
        var scaledCropArea: CGRect = CGRectMake(
            cropArea.origin.x * image.scale,
            cropArea.origin.y * image.scale,
            width * image.scale,
            height * image.scale
        )
   
        guard let cgImage = image.cgImage,
              let croppedImgRef = cgImage.cropping(to: scaledCropArea) else {
            return nil
        }
        
        return UIImage(cgImage: croppedImgRef,
                       scale: image.scale, orientation:
                        image.imageOrientation)
    }
}
