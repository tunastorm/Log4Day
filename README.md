프로젝트 정보
-

<br>

<div align="center">
  <img src = "https://github.com/user-attachments/assets/61809e71-67b6-44e0-b6db-1bf0006333ed" width="200" height="200"/>
</div>
<br>
<div align = "center">
   <img src = "https://github.com/user-attachments/assets/1aca363d-17e8-45b0-9e76-6cda7e1d89c3" width="80" height="20">
   <img src = "https://github.com/user-attachments/assets/ef2582ec-ab10-4893-99b9-41eb98571803" width="60" height="20">
   <img src = "https://github.com/user-attachments/assets/b37832bf-28fe-4d51-931c-0d1a3043636e" width="60" height="20">
</div>
<br>
<div align="center">
 <a href="https://apps.apple.com/kr/app/log4day-%EB%84%A4-%EC%BB%B7-%EC%82%AC%EC%A7%84-%EC%86%8D-%EC%98%A4%EB%8A%98-%ED%95%98%EB%A3%A8/id6736357381">
    <img src="https://github.com/user-attachments/assets/338e1811-008c-4ea3-9794-de94392af06e">
 </a>
</div>

<br>

> ### Log4Day

- 매일의 추억을 지도와 네컷사진으로 기록할 수 있는 서비스

<br>

> ### 스크린샷
![title](https://github.com/tunastorm/Log4Day/blob/tunastorm/ReadmeResource/Apple%20iPhone%2011%20Pro%20Max%20Screenshot%20All.png?raw=true)   

<br>

> ### 개발기간 
 2024.09.12 ~ 2024.10.08

<br>

> ### 개발인원
클라이언트(iOS) 1명

<br>

> ### 최소 지원 버전
iOS 15.0 이상

<br>

주요 기능
-

<br>

> ### 추억 관리
- 카테고리별 로그 조회
- 로그 상세 조회 / 수정 / 삭제
- 네 컷 사진 조회 / 갤러리 저장
- 방문 장소 조회 

<br>

> ### 일기 등록
- 방문장소 검색
- 방문장소 등록 / 삭제
- 방문장소 이미지 등록 / 삭제

<br>
 
> ### 카테고리 관리
- 카테고리 추가 / 삭제

<br>

> ### 유저분석 / 에러 탐지 / 푸시 알림 

<br>

기술 스택
- 

<br>

> ### Architecture & Design Pattern

* MVVM, Input-Output
* Repository, Router, Singleton

> ### Swift Libraries

* SwiftUI
* Combine
* UIKit

> ### External Libraries

* Alamofire
* RealmSwift
* Naver Maps API V3
* BottomSheet
* RealmSwift
* SnapKit
* SwiftUIX

<br>

구현 사항
-

<br>

> ### 프로젝트 구성도 

<div align= "center">
  <img src="https://github.com/tunastorm/Log4Day/blob/tunastorm/ReadmeResource/%E1%84%91%E1%85%B3%E1%84%85%E1%85%A9%E1%84%8C%E1%85%A6%E1%86%A8%E1%84%90%E1%85%B3%20%E1%84%80%E1%85%AE%E1%84%89%E1%85%A5%E1%86%BC%E1%84%83%E1%85%A9.png?raw=true"/>
</div>


> ### SwiftUI와 Combine, Input/Output 패턴으로 MVVM 아키텍처 구현

<br>

> ### iOS 16.0 이상에서 동작하는 Modifire와 이전 버전의 Modifire를 분기하는 Custom Modifire로 최소버전 iOS 15.0 대응

```swift
extension View {
    
    @ViewBuilder
    func hideIndicator() -> some View {
        if #available(iOS 16, *) {
            self.modifier(iOS16_HideIndicator())
        } else {
            self.modifier(iOS15_HideIndicator())
        }
    }
    
}

@available(iOS 16, *)
struct iOS16_HideIndicator: ViewModifier {
    
    func body(content: Content) -> some View {
        content.scrollIndicators(.hidden)
    }
}


struct iOS15_HideIndicator: ViewModifier {
    
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    func body(content: Content) -> some View {
        content
    }
}
```

<br>

> ### UIHostingController, UIGraphicsImageRenderer, CGImage.cropping으로 SwiftUI View를 UIImage로 변환

* 네컷사진 Cell 터치시 Cell의 View를 UIImage로 변환하는 전체 로직

```swift
  private func configContentView(contentView: Content, contentWidth: CGFloat, nextOffset: CGFloat, index: CGFloat) -> some View {
        contentView
        .frame(width: contentWidth, height: contentHeight)
        .gesture(
            DragGesture()
                .onEnded { value in
                   ......
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

                // 이미지 렌더러 생성
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))

                // 네 컷 사진 이미지 렌더링
                let rawFourCutImage = renderer.image { context in
                    // UIHostingController의 view가 가진 layer Tree를 UIGraphicsImageRendererContext에 작성
                    framedController.view.layer.render(in: context.cgContext)
                }
                
                framedController.view.removeFromSuperview()
      
                // 네 컷 사진 이미지에서 불필요한 영역 cropping
                guard let fourCutImage = cropWithDate(rawFourCutImage) else {
                    return
                }
                viewModel.action(.fourCutCellPressed(image: fourCutImage))
            }
        }
    }
```

* 네컷사진 이미지에 배경 디자인 적용한 UIHostingController 생성
```swift
private func setFourCutImageFrame(_ contentView: Content) -> UIHostingController<some View> {
        var date = ""
        
        if let photoView = contentView as? FourCutPictureView {
            let rawDate = photoView.photos.first?.owner.first?.startDate ?? Date()
            date = DateFormatManager.shared.dateToFormattedString(date: rawDate, format: .dotSeparatedyyyyMMddDay)
        }
        
        let edittedContentView = contentView
                                    .background(.clear)
                                    .opacity(1.5)
        
        let controller = UIHostingController(rootView: edittedContentView)
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
        
        let appTitleLabel = {
            let label = UILabel()
            label.text = "Log4Day"
            label.font = .boldSystemFont(ofSize: 16)
            label.textAlignment = .right
            label.textColor = .systemMint
            label.layer.opacity = 0.75
            return label
        }()
        
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

        return controller
    }
```

* UIImage Cropping
```swift
 private func cropWithDate(_ image: UIImage) -> UIImage? {
        
    let width = UIScreen.main.bounds.width - 25
    let height = UIScreen.main.bounds.height - 170
  
    // UIImage 기준의 cropArea (device의 scale 반영되지 않음)
    let cropArea = CGRect(x: 0, y: 60,
                          width: image.size.width ,
                          height: image.size.height)

    // device의 scale만큼 CropArea의 크기 확대
    var scaledCropArea: CGRect = CGRectMake(
        cropArea.origin.x * image.scale,
        cropArea.origin.y * image.scale,
        width * image.scale,
        height * image.scale
    )

    // cgImage의 size는 device의 scale이 곱해진 값이므로 scaledCropArea로 cropping 
    guard let cgImage = image.cgImage,
          let croppedImgRef = cgImage.cropping(to: scaledCropArea) else {
        return nil
    }
    
    return UIImage(cgImage: croppedImgRef, 
                   scale: image.scale, orientation:
                    image.imageOrientation)
}
```


<br>

> ### UIViewRepresentable의 Coordinator에서 지도 Overlay 객체들을 관리해 지도 View의 re-rendering으로 발생하는 @Binding 프로퍼티들의 초기화에 대응

```swift
```

<br>

> ### @NameSpace로 View 객체의 애니메이션 구현

* TabBarView (상위뷰)

```swift
struct TapBarView: View {
    
    @ObservedObject var categoryViewModel: CategoryViewModel
    @EnvironmentObject var viewModel: MyLogViewModel
    @Namespace private var animation

    var body: some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            Section(header: TopTabbar(animation: animation)
                            .environmentObject(viewModel)
            ) {
                switch viewModel.output.selectedPicker {
                case .timeline:
                    timelineList()
                case .place:
                    placeList()
                }
            }
        }
        .onAppear {
            viewModel.action(.tapBarChanged(info: viewModel.output.selectedPicker))
        }
    }
```

* TabBar (하위 뷰)
```swift
struct TopTabbar: View {
    
    @EnvironmentObject var viewModel: MyLogViewModel
    var animation: Namespace.ID
    
    var body: some View {
        HStack {
            ForEach(TapInfo.allCases, id: \.self) { item in
                LazyVStack {
                    Text(item.rawValue)
                        .font(.headline)
                        .frame(maxWidth: .infinity/4, minHeight: 30)
                        .foregroundColor(viewModel.output.selectedPicker == item ?
                            .mint: .gray)
                        .padding(.horizontal)
                    if viewModel.output.selectedPicker == item {
                        Capsule()
                            .foregroundColor(ColorManager.shared.ciColor.highlightColor)
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "info", in: animation)
                            .padding(.horizontal)
                    }
                }
                .onTapGesture {
                    withAnimation(.none) {
                        viewModel.action(.tapBarChanged(info: item))
                    }
                }
            }
        }
        .background(ColorManager.shared.ciColor.backgroundColor)
    }
}
```

<br>

> ### @EnvironmentObject, @ObservedObject 어노테이션을 통한 상위 뷰와 하위 뷰의 ViewModel 인스턴스 공유
```swift
struct MyLogView: View {
    
    @Binding var tapSelection: Int
    
    @ObservedObject var categoryViewModel: CategoryViewModel
    @StateObject private var viewModel = MyLogViewModel()
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack {
                    NavigationBar(
                        ......
                    )
                    ScrollView {
                        LazyVStack(pinnedViews: [.sectionHeaders]) {
                            Section(header: TitleView()) {
                               ......
                            }
                            if viewModel.output.logList.isEmpty {
                                ......
                            } else {
                                // @StateObject인 MyLogViewModel의 인스턴스 .environmentObject() Modifire로 하위뷰에 공유
                                // @ObservedObejct인 CategoryViewModel의 인스턴스 하위 뷰의 생성자로 넘겨 공유
                                TapBarView(categoryViewModel: categoryViewModel)
                                    .environmentObject(viewModel)
                            }
                        }
                    }
                    .frame(width: viewModel.output.screenWidth)
                }
                // @StateObject인 MyLogViewModel의 인스턴스 .environmentObject() Modifire로 하위뷰에 공유
                // @ObservedObejct인 CategoryViewModel의 인스턴스 하위 뷰의 생성자로 넘겨 공유
                SideBarView(controller: .myLog, viewModel: categoryViewModel)
                    .environmentObject(viewModel)
            }
        }

        ......

    }

    ......

}
```
<br>

> ### GeometryReader기반 Custom Infinity Carousel View와 Cell에 대한 반복적인 Drag 이벤트 발생 제어

* 네컷사진 Cell 생성
```swift
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
                        // 0, 마지막 순서의 데이터가 들어가는 더미 Cell
                        configContentView(contentView: zeroContent(0,$currentIndex, lastCell),
                                          contentWidth: contentWidth,
                                          nextOffset: nextOffset, index: 0)
                        // 1 ~ data.count, 사용자에게 노출되는 Cell 
                        ForEach(0..<data.count, id: \.self) { index in
                            let view = carouselContent(data[index], CGFloat(index+1), $currentIndex, lastCell)
                            configContentView(contentView: view,
                                              contentWidth: contentWidth,
                                              nextOffset: nextOffset, index: CGFloat(index + 1))
                        }
                        // data.count + 1, 첫번째 순서의 데이터가 들어가는 더미 Cell
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
```

* 네컷사진 offset으로 Cell Scroll 및 반복적인 Drag 이벤트 발생 제어
```swift
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
                    // Drag 이벤트가 완료되어도 0.3초 대기한 후에 isDragging 값 변경해, 이벤트의 중복발생 방지
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isDragging = false
                    }
                }
        )
```


<br>

> ### DispatchGroup으로 PHPickerView로 선택한 이미지의 로드 시점 제어

```swift

import SwiftUI
import UIKit
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {

    @ObservedObject var viewModel: LogDetailViewModel
    
    @Binding var isPresented: Bool
    
    var configuration: PHPickerConfiguration
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        ......
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        ......    
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, viewModel)
    }
 
    class Coordinator: PHPickerViewControllerDelegate {
        
        @ObservedObject var viewModel: LogDetailViewModel
        
        private let parent: PhotoPicker
        private var selections = [String : PHPickerResult]()
        private var selectedAssetIdentifiers = [String]()
        
        private var imageList: [UIImage] = []
        
        init(_ parent: PhotoPicker, _ viewModel: LogDetailViewModel) {
            self.parent = parent
            self.viewModel = viewModel
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

            parent.isPresented = false
        
            viewModel.action(.changeLoadingState)

            // 선택된 이미지들을 로드하기 전에 DispatchGroup 생성
            let group = DispatchGroup()
            results.forEach { [weak self] in
                $0.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                    // DispatchGroup에 추가
                    group.enter()
                    DispatchQueue.main.async() {
                        if let image = object as? UIImage {
                            
                            self?.imageList.append(image)
                            
                            if let imageList = self?.imageList, imageList.count == results.count {
                                self?.viewModel.input.pickedImages = imageList
                                self?.viewModel.action(.photoPicked)
                            }
                        }
                        // 이미지 로드 완료 후 DispatchGroup에서 해제
                        group.leave()
                    }
                }
            }
            viewModel.action(.changeLoadingState)
        }
        
    }
    
}
```

<br>

> ### View를 감싸는 WrapperView로 ForEach로 생성되는 NavigationLink의 메모리 부하 관리

* NextViewWrapper

```swift
import SwiftUI

struct NextViewWrapper<Content: View>: View {
    
    typealias InitContent = () -> Content
    
    let view: InitContent
    
    var body: some View {
        view()
    }
    
    init(_ view: @autoclosure @escaping InitContent) {
        self.view = view
    }
    
}
```

* NavigationLink 렌더링 시 NextViewWrapper만 렌더링하며 다음 화면의 View는 클릭 이벤트 발생시에 렌더링되어 메모리 부하 감소
  
```swift
private func timelineList() -> some View {
      LazyVStack {
          ForEach(viewModel.output.timeline.indices, id: \.self) { index in
              NavigationLink {
                  NextViewWrapper(
                      LogDetailView(
                          logId: viewModel.output.ofLogList[index].id,
                          categoryViewModel: categoryViewModel,
                          myLogViewModel: viewModel
                      )
                  )
              } label: {
                  let log = viewModel.output.timeline[index]
                  return TimelineCell(index: index,
                                      title: log.title,
                                      startDate: log.startDate,
                                      fourCutCount: log.fourCut.count)
                      .environmentObject(viewModel)
              }
          }
      }
      .background(.clear)
      .frame(maxWidth: .infinity)
      .padding()
}
```

> ### @ObservedResult로 RealmObject 추가 / 수정 / 삭제 후 갱신이 불필요한 @Publish 프로퍼티 구성

```swift
```

<br>

> ### RealmSwift와 FileManager를 사용한 이미지 저장 및 로드

```swift

```

<br>

트러블 슈팅
-

<br>

> ### 지도 Representable 객체 비동기 처리
 - 선택된 마커/장소에 대한 이벤트 처리가 1~2초가량 지연되는 이슈
 - 사용자가 선택한 장소의 위치를 입력받는 프로퍼티에 view의 변경이 없는 viewModel의 변경은 예측되지 않은 동작을 일으킬 수 있다는 보라색 경고 발생
 - updateView 메서드의 로직을 Main큐에서 비동기 처리하도록 개선
 - 마커 선택 및 장소 셀 선택 시 즉각적인 반응

<br>

> ### 이미지 다운 샘플링
- 서비스 기획상 현재 2개의 뷰에서 지도 SDK를 사용해야만 하는 만큼 최소 200MB의 메모리 부하를 디폴트로 감당해야하는 상태. 
- 원본 이미지를 그대로 사용하게되면 지도뷰에서 장시간 또는 대량의 작업이 일어날 경우 쉽게 메모리에 과도한 부하발생 가능
- WWDC에서 SwiftUI에서 제공하는 Image의 resizable이나 UIGraphicsImageRenderer보다 더 효율적인 방법으로 소개된 ImageIO를 사용한 다운샘플링 구현
- 전 후 성능비교

<br>

회고
-

<br>

> ### 성취점
* SwiftUI와 Combine을 결합한 MVVM 아키텍처 구현
* 최소버전을 iOS 15로 대응하는 데 성공
* Naver 지도 SDK의 오버레이 객체들을 활용해 지도에 마커, 경로, 사진을 추가하는 로직 구현에 성공

<br>

> ### 개선사항
* 선언형 UI인 SwiftUi에서 @ObservedObject, @EnvironmentObject와 함께 ViewModel을 사용하는 것이 알맞을까 의문이 듦. MVI나 TCA를 공부해보자. 
* 네트워크, Realm CRUD 등의 예외처리 및 alert등을 통한 결과 안내 로직 추가
* 커스텀으로 구현한 Infinity Carousel View의 딱딱한 스크롤 애니메이션을 SwiftUI에 어울리게 개선

<br>
