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

> ### iOS 16.0 이상에서 동작하는 Modifire와 이전 버전의 Modifire를 분기하는 Custom Modifire로 최소버전 iOS 15.0 대응

* NavigationView와 NavigationStack 분기
* ScrollView indicator 메서드 분기
* 그 외 iOS15 기준으로 코드 작성

<br>

> ### UIHostingController, UIGraphicsImageRenderer, CGImage.cropping으로 SwiftUI View를 UIImage로 변환

* UIHostingController의 rootView에 SwiftUI View 할당
  
* UIHostingController는 UIViewController를 상속하므로 UIViewController의 프로퍼티와 메서드들 사용해 이미지의 배경에 사용될 뷰 구성
* UIGraphicsImageRenderer 인스턴스 생성 및 UIHostingController의 view가 가진 layer Tree를 UIGraphicsImageRendererContext에 작성
* 렌더링을 수행하여 UIImage 생성
* CGImage.cropping을 사용하여 불필요한 영역 crop
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

* SwiftUI에서는 화면을 구성하는 View 객체들을 메서드나 구조체로 분리하는 것이 권장된다.
* 한 화면을 구성하는 상위 뷰와 하위 뷰들이 같은 ViewModel 인스턴스와 이벤트를 주고받아야 상호 간의 데이터의 일관성이 유지될 수 있다.
* 하위뷰가 상위뷰가 가진 ViewModel 인스턴스를 전달받기 위해서 필요한 ViewModel 타입의 @EnvironmentObject나 @ObservedObject를 선언
* 전달되는 ViewModel에 @ObservableObject 프로토콜을 채택하고 상위뷰에서 environmentObject Modifier를 사용하거나 생성자에 뷰모델 인스턴스를 인자로 넘겨 공유
* 같은 ViewModel을 공유하는 View 간에는 별도의 로직없이도 최신상태 공유 가능.

<br>

> ### GeometryReader로 구현한 Custom Infinity Carousel View와 Cell에 대한 반복적인 Drag 이벤트 발생 제어

* GeometryReader기반 Custom Infinity Carousel View
  - Realm에서 조회한 일기 목록 중 네 장의 사진이 등록되어있는 것만 필터링한 리스트를 @Binding으로 주입
  - ViewModel에서 전달받은 data의 last를 0번 Cell, first를 data.count + 1번 Cell에 복사한 후,전체 Cell을 HStack에 생성
  - GeometryReader로 화면의 크기를 구한 후 1개 Cell이 차지할 범위를 지정. Drag 이벤트 발생 시 현재 셀의 offset을 기반으로 페이지네이션
  - 0번 Cell과 마지막 Cell은 1번과 data.count번 Cell의 옆을 채워줄 더미이고 실제 뷰에 표시되는 Cell의 범위는 1번 ~ data.count까지.
  - 실제 뷰에 표시되는 Cell의 시작과 끝 사이의 이동은 0번 / 마지막 Cell로 이동 후, data.count번 / 1번 Cell로 offset을 옮겨서 구현

* 반복적인 Drag 이벤트 발생 제어
  - @State에 Drag이벤트 진행중인지 체크하는 Bool 선언
  - Cell에 Drag이벤트 발생시 true
  - Drag이벤트가 종료될 때 DispatchQueue.main.asyncAfter로 시간을 지연시킨 후 false 할당

<br>

> ### DispatchGroup으로 PHPickerView로 선택한 이미지의 로드 시점 제어

* PHPickerViewController의 UIViewControllerRepresentable에서 이미지 로드 시 비동기로 작동
* PHPickerViewControllerDelegate의 picker( _picker:, didFinishPicking: ) 메서드에서 선택된 사진들을 순회하며 load하기 전에 DispatchGroup을 생성
* 사진들을 순회할 때마다 enter()를 실행하고 각 사진들을 UIImage로 변환하여 ViewModel의 input으로 전달한 후 leave()하는 방식으로 작업완료시점 제어
* 모든 사진들을 ViewModel의 input에 전달한 다음 사진 등록작업 완료 action 전파

<br>

> ### View를 감싸는 WrapperView로 ForEach로 생성되는 NavigationLink의 메모리 부하 관리

* 제네릭 타입 매개변수의 제약조건으로 View를 갖고 View를 상속하는 구조체 NextViewWrapper를 선언
  - 생성자의 view 매개변수에 @autoclosure 키워드를 사용하여 생성자 사용시 입력되는 클로저의 중괄호 묶음 생략
  - 또한 @escaping 키워드로 클로저 내부의 View를 NextViewWrapper의 view 프로퍼티에 할당할 수 있도록 허용

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

* ForEach문 안에서 NavigationLink 렌더링 시 NextViewWrapper만 렌더링하여 메모리 부하 감소
  - 연결된 화면의 View는 클릭 이벤트 발생시에 렌더링된다

<br>

> ### @ObservedResult로 RealmObject 추가 / 수정 / 삭제 후 갱신이 불필요한 @Publish 프로퍼티 구성

* ViewModel의 Output Stuct의 프로퍼티에 일기의 목록을 담는 @ObservedResult 선언

* @ObservedResult는 Environment Value인 realmConfiguration을 따르므로 RealmDB 데이터에 변화가 있을 때에 이를 관찰할 수 있다.

* View에서는 viewModel.output을 참조해 @ObservedResult가 변경될 때마다 새로 렌더링되며 데이터를 갱신하며

* Repository에서 추가 / 삭제 / 수정이 발생하더라도 별도의 로직 구현없이 실시간으로 View 갱신된다    

<br>

> ### RealmSwift와 FileManager를 사용한 이미지 저장 / 삭제

* Singleton으로 구현한 FileManager 클래스가 이미지 조회 / 저장 / 삭제 담당
  - View에서의 이미지 조회
  - ViewMopdel과 Repository에서의 저장 / 삭제 시 호출

* Realm의 일기 Object가 등록된 이미지 파일명의 배열을 가짐 

* Repository에서 일기 또는 일기의 List를 갖는 카테고리를 삭제할 때 일기가 가진 이미지 목록을 순회하며 삭제. 


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
    
|일기 작성 탭|일기 조회 화면|
|------|------|
|<img width="307" alt="스크린샷 2024-10-22 오후 4 36 55" src="https://github.com/user-attachments/assets/73fed617-7272-444e-9c53-51fc93e2e716">| <img width="306" alt="스크린샷 2024-10-22 오후 4 38 24" src="https://github.com/user-attachments/assets/1045f48c-c8f5-4cda-b8ee-178a0dcc2730">|

* 이미지 개수를 최대 4개로 제한했지만 원본 이미지를 그대로 사용하게 되면 4개만 등록해도 메모리에 과도한 부하발생
     
|일기 작성 탭|일기 조회 화면|
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

|일기 작성 탭|일기 조회 화면|
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
* 선언형 UI인 SwiftUI에서 @ObservedObject, @EnvironmentObject, ViewModel을 여러 View에 걸쳐서 사용하는 것이 좋은 방향인지 의문이 듦. MVI 아키텍처나 TCA를 적용해보고 싶다.
* 네트워크, Realm CRUD 등의 예외처리 및 alert등을 통한 결과 안내 로직 추가
* 커스텀으로 구현한 Infinity Carousel View의 딱딱한 스크롤 애니메이션을 SwiftUI에 어울리게 개선

<br>
