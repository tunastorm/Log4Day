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

> ### 스크린샷
![title](https://github.com/tunastorm/Log4Day/blob/tunastorm/ReadmeResource/Apple%20iPhone%2011%20Pro%20Max%20Screenshot%20All.png?raw=true)   

> ### 개발기간 
 2024.09.12 ~ 2024.10.08

> ### 개발인원
클라이언트(iOS) 1명

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

> ### 일기 등록
- 방문장소 검색
- 방문장소 등록 / 삭제
- 방문장소 이미지 등록 / 삭제
 
> ### 카테고리 관리
- 카테고리 추가 / 삭제

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

* ViewModel
  - Input과 Output 구조체에 Subject와 View로 내보낼 데이터를 초기화하고 이를 ViewModel의 input, output 프로퍼티에 초기화
  - init시점에 input 프로퍼티에 초기화된 PassthroughSubject를 sink가 구독
  - action 메서드를 통해 View에서 input 이벤트가 전달되면 매칭되는 PassthroughSubject Stream에서 연산을 위한 이벤트를 방출
  - 연산 결과를 output의 프로퍼티에 업데이트하면 output 프로퍼티에 적용된 @Published의 효과로 View에 선언된 @SateObject / @ObservedObject 작동

* View
  - viewModel.action(_ action: Action)을 통해 input 이벤트 전달
  - viewModel.output에 변경이 발생했을 때 @StateObject / @ObservedObject의 효과로 새롭게 렌더링되며 이때 output의 변경사항이 반영됨

<br>

> ### UIHostingController, UIGraphicsImageRenderer, CGImage.cropping으로 SwiftUI View를 UIImage로 변환

* UIHostingController의 rootView에 SwiftUI View 할당
  
* UIHostingController는 UIViewController를 상속하므로 UIViewController의 프로퍼티와 메서드들 사용해 이미지의 배경에 사용될 뷰 구성
* UIGraphicsImageRenderer 인스턴스 생성
* UIHostingController의 view가 가진 layer Tree를 UIGraphicsImageRendererContext에 작성
* 네 컷 사진 이미지 렌더링하여 UIImage 생성
* CGImage.cropping을 사용하여 불필요한 영역 crop 가능
   - crop영역 설정 시 현재 사용중인 device의 scale만큼 size를 확대해야 함
   - UIImage의 size는 device의 scale을 반영하지 않은 값을 반환하지만, CGImage는 scale을 반영한 size를 갖기 때문
* Naver Maps API SDK에서도 위 방식으로 변환한 UIImage로 NMFMarkerImage를 생성해 커스텀 마커 적용

<br>

> ### UIViewRepresentable의 Coordinator에서 지도 Overlay 객체들을 관리해 지도 View의 re-rendering으로 발생하는 @Binding의 초기화에 대응

* Naver 지도 UIViewRepresentable 구조체에 사용된 @Binding 프로퍼티
  - 현재 선택된 장소의 index
  - 지도에 표기할 장소정보 배열
  - 장소 index와 이미지 배열을 key-value로 갖는 딕셔너리
  - NMGLatLng(좌표) 배열
 
* viewModel의 output이 변경되어 현재 선택된 장소 순서가 변경될 때마다 Naver 지도 SDK를 래핑한 UIViewRepresentable 구조체가 새로 렌더링 되어 프로퍼티의 값이 초기화 된다.
  - 렌더링 직전의 값이 사라지고 초기화 됨
* 최초 생성 후엔 초기화되지 않는 coordinator 클래스가 @Binding을 통해 업데이트 되는 데이터들의 변경사항을 반영한 뒤 자신의 프로퍼티에 저장해 최신 상태 기억
* UIViewRepresentable의 updateUIView메서드에서는 cooridnator의 프로퍼티에 저장된 최신 상태를 Naver 지도 뷰에 업데이트하는 작업만 수행

<br>

> ### @NameSpace로 View 객체의 화면 이동 애니메이션 구현

* @Namespace를 선언해 자신이 저장한 Identifier들이 부여된 View들을 애니메이션 효과를 적용할 하나의 그룹으로 구분

* 애니메이션을 적용할 View들에 matchedGeometryEffect Modifier를 적용하고 각자의 ID 부여하고, Namespace 지정 

* 동일한 Namespace를 공유하는 View들끼리 애니메이션이 적용됨

<br>

> ### @EnvironmentObject, @ObservedObject 어노테이션을 통한 상위 뷰와 하위 뷰의 ViewModel 인스턴스 공유

* 

<br>

> ### GeometryReader로 구현한 Custom Infinity Carousel View와 Cell에 대한 반복적인 Drag 이벤트 발생 제어

* GeometryReader기반 Custom Infinity Carousel View
  - Realm에서 조회한 일기 목록 중 네 장의 사진이 등록되어있는 것만 필터링한 리스트를 @Binding으로 주입
  - ViewModel에서 전달받은 data의 last를 0번 Cell, first를 data.count + 1번 Cell에 복사한 후,전체 Cell을 HStack에 생성
  - GeometryReader로 화면의 크기를 구한 후 1개 Cell이 차지할 범위를 지정. 현재 셀의 offset을 기반으로 페이지네이션
  - 0번 Cell과 마지막 Cell은 1번과 data.count번 Cell의 옆을 채워줄 더미이고 실제 뷰에 표시되는 Cell의 범위는 1번 ~ data.count까지.
  - 실제 뷰에 표시되는 Cell의 시작과 끝 사이의 이동은 0번 / 마지막 Cell로 이동 후, data.count번 / 1번 Cell로 offset을 옮겨서 구현

* 네컷사진 offset으로 Cell Scroll 및 반복적인 Drag 이벤트 발생 제어



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
                  ......
              }
          }
      }
      .background(.clear)
      .frame(maxWidth: .infinity)
      .padding()
}
```
<br>

> ### @ObservedResult로 RealmObject 추가 / 수정 / 삭제 후 갱신이 불필요한 @Publish 프로퍼티 구성

* Output Stuct의 프로퍼티에 @ObservedResult 선언

```swift
final class MyLogViewModel: ObservableObject {
    
    private let repository = Repository.shared
    
    private let photoManager = PhotoManager()
    
    private var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    
    @Published var output = Output()
    
    enum Action {
        case changeCategory
        ......
        case fetchCategorizedList
        ......
    }
    
    struct Input {
        let changeCategory = PassthroughSubject<Void, Never>()=
        ......
        let fetchCategorizedList = PassthroughSubject<Void, Never>()
        ......
    }
    
    struct Output {
        ......
        var category = "전체"
        @ObservedResults(Log.self) var logList
        ......
    }
    
    init() {
        ......
        input.fetchCategorizedList
            .sink { [weak self] _ in
                self?.fetchCategorizedLogList()
            }
            .store(in: &cancellables)
        ......
    }
    
    func action(_ action: Action) {
        switch action {
        ......
        case .fetchCategorizedList:
            input.fetchCategorizedList.send(())
        ......
        }
    }

    ......

    private func fetchCategorizedLogList() {
        if output.category == "전체" {
            output.$logList.where = { $0.startDate <= Date() }
        } else {
            output.$logList.where = { [weak self] in
                return $0.owner.title == self?.output.category ?? ""
            }
        }
        output.$logList.sortDescriptor = .init(keyPath: Log.Column.startDate.name, ascending: false)
        output.$logList.update()
        fetchFirstLastDate()
    }

    ......

}
```

<br>

> ### RealmSwift와 FileManager를 사용한 이미지 저장 / 삭제

* Repository
```swift
import Foundation
import RealmSwift

final class Repository {
    
    typealias RepositoryResult = (Result<RepositoryStatus, RepositoryError>) -> Void
    typealias propertyhandler = () -> Void
    
    static let shared = Repository()
    
    private let photoManager = PhotoManager()
    
    private let realm = {
        do {
            return try? Realm(configuration: RealmConfiguration.getConfig())
        } catch {
            return nil
        }
    }()

    ......

    func deleteCategory(_ data: Category, completionHandler: RepositoryResult) {
        let logs = data.content
        do {
            try realm?.write { [weak self] in
                logs.forEach { log in
                    log.places.forEach { self?.realm?.delete($0) }
                    log.fourCut.forEach {
                        self?.photoManager.removeImageFromDocument(filename: $0.name)
                        self?.realm?.delete($0)
                    }
                    self?.realm?.delete(log)
                }
                self?.realm?.delete(data)
            }
            completionHandler(.success(RepositoryStatus.deleteSuccess))
        } catch {
            completionHandler(.failure(RepositoryError.deleteFailed))
        }
    }
    
    func deleteLog(_ log: Log, completionHandler: RepositoryResult) {
        do {
            try realm?.write { [weak self] in
                log.places.forEach{ self?.realm?.delete($0) }
                log.fourCut.forEach {
                    self?.photoManager.removeImageFromDocument(filename: $0.name)
                    self?.realm?.delete($0)
                }
                self?.realm?.delete(log)
            }
            completionHandler(.success(RepositoryStatus.deleteSuccess))
        } catch {
            completionHandler(.failure(RepositoryError.deleteFailed))
            
        }
    }

    ......

}
```


* FileManager
  
```swift
import UIKit

final class PhotoManager: FileManager {
  
    static let shared = PhotoManager()
    
    private var documentDirectory: URL?
    
    override init() {
        self.documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first
    }
    
    func saveImageToDocument(image: UIImage, filename: String) {
        // document 위치 할당
        guard let documentDirectory else { return }
        
        //이미지를 저장할 경로(파일명) 지정
        let fileURL = documentDirectory.appendingPathComponent("\(filename).png")
        
        //이미지 압축
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        //이미지 파일 저장
        do {
            try data.write(to: fileURL)
        } catch {
            print("file save error", error)
        }
    }
    
    func loadImageFromDocument(filename: String) -> UIImage? {
       ......
    }
    
    func removeImageFromDocument(filename: String) -> Bool? {
        guard let documentDirectory else { return nil }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).png")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                return true
            } catch {
                print(#function, "file remove error", error)
                return false
            }
        } else {
            return nil
        }
    }
}

```

<br>

트러블 슈팅
-

<br>

> ### 지도 Representable 객체 비동기 처리
* 선택된 마커/장소에 대한 이벤트 처리가 1~2초가량 지연되는 이슈

![markerAsync_before-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/b88b48da-8988-49d0-b477-ce3936e0f2d8)
   
* 사용자가 선택한 장소의 위치를 입력받는 프로퍼티에 view의 변경이 없는 viewModel의 변경은 예측되지 않은 동작을 일으킬 수 있다는 메모리 이슈 경고 발생

<img width="1064" alt="스크린샷 2024-10-22 오후 4 06 53" src="https://github.com/user-attachments/assets/eca3c4bf-8988-4551-9029-684e5bf87fd8">
 
* updateView 메서드의 로직을 Main큐에서 비동기 처리하도록 개선

```swift
func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
    DispatchQueue.main.async() {
        //MARK: 카메라 위치 갱신
        ......
        
        //MARK: 오버레이 요소 갱신
        ......
        
        //MARK: 마커에 맵뷰 할당
        ......
        
        //MARK: 마커 간의 직선 갱신
        ......
        
        //MARK: 카메라 이동 애니메이션
        ......
    }
}
```

* 마커 선택 및 장소 셀 선택 시 반응속도 개선

![markerAsync_After-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/da09cbcb-9b61-430a-b400-b5301844cb67)

<br>

> ### 이미지 다운 샘플링
* 서비스 기획상 현재 2개의 뷰에서 지도 SDK를 사용해야만 하는 만큼 최소 200MB 가량의 메모리 부하를 디폴트로 감당해야하는 상태.
  - 일기 작성 탭의 100MB는 고정, 일기 조회화면의 100MB가량은 화면에서 벗어날 시 해제됨
    
|일기작성 탭|일기 조회 화면|
|------|------|
|<img width="307" alt="스크린샷 2024-10-22 오후 4 36 55" src="https://github.com/user-attachments/assets/73fed617-7272-444e-9c53-51fc93e2e716">| <img width="306" alt="스크린샷 2024-10-22 오후 4 38 24" src="https://github.com/user-attachments/assets/1045f48c-c8f5-4cda-b8ee-178a0dcc2730">|

* 이미지 개수를 최대 4개로 제한했지만 원본 이미지를 그대로 사용하게되면 메모리에 과도한 부하발생
   - 사용자가 촬영한 사진 4장 등록한 경우
     
|일기작성 탭|일기 조회 화면|
|------|------|
|<img width="305" alt="스크린샷 2024-10-22 오후 4 54 31" src="https://github.com/user-attachments/assets/f3166cab-7862-4132-ac4d-4a0d0282e798"> | <img width="301" alt="스크린샷 2024-10-22 오후 4 56 52" src="https://github.com/user-attachments/assets/5df9b98f-bdc7-46d9-81ce-3086688d8036">|

* WWDC에서 SwiftUI에서 제공하는 Image의 resizable이나 UIGraphicsImageRenderer보다 더 효율적인 방법으로 소개된 ImageIO를 사용한 다운샘플링 구현
  - UIImage Extension
  ```swift
  import ImageIO
  import UIKit
  
  extension UIImage {
          
      func resize(to size: CGSize) -> UIImage? {
             let options: [CFString: Any] = [
                 kCGImageSourceShouldCache: false,
                 kCGImageSourceCreateThumbnailFromImageAlways: true,
                 kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
                 kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height),
                 kCGImageSourceCreateThumbnailWithTransform: true
             ]
             
             guard let data = pngData(),
                   let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
                   let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)
             else { return nil }
             
             let resizedImage = UIImage(cgImage: cgImage)
             return resizedImage
      }
     
  }
  ```

  - PHPickerView
  ```swift
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

      parent.isPresented = false
  
      viewModel.action(.changeLoadingState)
      
      let width = ScreenSize.width - 75
      let height = ScreenSize.height - 312
    
      let group = DispatchGroup()
      results.forEach { [weak self] in
          $0.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
              group.enter()
              DispatchQueue.main.async() {
                  if let rawImage = object as? UIImage,
                     // 원본 UIImage를 resize하여 메모리 최적화
                     let image = rawImage.resize(to: CGSize(width: width, height: height)) {
                      
                      self?.imageList.append(image)
                      
                      if let imageList = self?.imageList, imageList.count == results.count {
                          self?.viewModel.input.pickedImages = imageList
                          self?.viewModel.action(.photoPicked)
                      }
                  }
                  group.leave()
              }
          }
      }
      viewModel.action(.changeLoadingState)
  }
  ```
      
* 다운 샘플링 적용 후 사진 4장 추가 시 메모리 부하 개선

|일기작성 탭|일기 조회 화면|
|------|------|
|<img width="344" alt="스크린샷 2024-10-22 오후 5 24 50" src="https://github.com/user-attachments/assets/16030903-657b-4383-9894-05a23950b8e4"> | <img width="343" alt="스크린샷 2024-10-22 오후 5 25 59" src="https://github.com/user-attachments/assets/6b5ef375-3960-4f33-9568-a4d355596aea">|


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
* 선언형 UI인 SwiftUI에서 @ObservedObject, @EnvironmentObject와 함께 ViewModel을 여러 View에 걸쳐서 사용하는 것이 알맞을까 의문이 듦. MVI 아키텍처나 TCA를 적용해보고 싶다.
* 네트워크, Realm CRUD 등의 예외처리 및 alert등을 통한 결과 안내 로직 추가
* 커스텀으로 구현한 Infinity Carousel View의 딱딱한 스크롤 애니메이션을 SwiftUI에 어울리게 개선

<br>
