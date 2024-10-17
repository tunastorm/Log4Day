![Download_on_the_App_Store_Badge_KR_RGB_blk_100317](https://github.com/user-attachments/assets/338e1811-008c-4ea3-9794-de94392af06e)프로젝트 정보
-

<br>

<div align="center">
  <img src = "https://github.com/user-attachments/assets/61809e71-67b6-44e0-b6db-1bf0006333ed" width="200" height="200"/>
</div>
<br>
<div align = "center">
  <img src = "https://img.shields.io/badge/App_Store-0D96F6?style=for-the-badge&logo=app-store&logoColor=white"> 
   <img src = "https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white">
   <img src = "https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white">
</div>
<div align="center">
 <a href="https://apps.apple.com/kr/app/log4day-%EB%84%A4-%EC%BB%B7-%EC%82%AC%EC%A7%84-%EC%86%8D-%EC%98%A4%EB%8A%98-%ED%95%98%EB%A3%A8/id6736357381">
   <img src="https://github.com/user-attachments/assets/322cd07e-b37f-4865-86cf-f76b76c686b9">
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
클라이언트 1명

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
* Singleton, Router

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

구현 사항 - 포폴에 작성한 개념도 활용
-

<br>

> ### 프로젝트 구성도 

<div align= "center">
  <img src="https://github.com/tunastorm/Log4Day/blob/tunastorm/ReadmeResource/%E1%84%91%E1%85%B3%E1%84%85%E1%85%A9%E1%84%8C%E1%85%A6%E1%86%A8%E1%84%90%E1%85%B3%20%E1%84%80%E1%85%AE%E1%84%89%E1%85%A5%E1%86%BC%E1%84%83%E1%85%A9.png?raw=true"/>
</div>


> ### SwiftUI와 Combine을 결합한 MVVM Architecture

<br>

> ### SwiftUI의 AppDelegate와 Realm Migration

<br>

> ### UIHostingController, UIGraphicsImageRenderer, CGImage.cropping으로 SwiftUI View를 UIImage로 변환 후 갤러리 저장

<br>

> ### UIViewRepresentable의 Coordinator로 지도 오버레이 객체 관리

<br>

> ### ImageIO Framework Image DownSampling

<br>

> ### Firebase Config 및 RemotePush

<br>

> ### GeometryReader, @NameSpace로 View 객체의 애니메이션 구현 

<br>

> ### @EnvironmentObject, @ObservedObject 어노테이션을 통한 상위 뷰와 하위 뷰의 ViewModel 인스턴스 공유

<br>

> ### SwiftUI에서의 Custom Infinity Carousel View와 Cell에 대한 반복적인 Touch 이벤트 제어

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
- WWDC에서 SwiftUI에서 제공하는 Image의 resizable이나 UIGraphicsImageRenderer보다 더 효율적인 방법으로 소개된ImageIO를 사용한 다운샘플링 구현
- 전 후 성능비교

<br>

회고
-

<br>

> ### 성취점

* SwiftUI와 Combine을 결합한 MVVM 아키텍처 구현
* 최소버전을 iOS 15로 대응하는 데 성공
* Naver 지도 SDK의 오버레이 객체들을 활용해 지도에 마커, 경로, 사진을 추가하는 로직 구현에 성공
* View에 사용되는 Model 타입별로 viewModel 구현, View가 변경되어도 동일 기능에 대한 코드 재사용성 확보

<br>

> ### 개선사항
* View - ViewModel - Model간 의존성 역진 및 의존성 주입이 가능한 구조로 변경
* 네트워크, Realm CRUD 등의 예외처리 및 alert등을 통한 결과 안내 로직 추가
* ViewModel과 View간의 의존성 해소
* 커스텀으로 구현한 무한 페이지네이션 뷰의 딱딱한 스크롤 애니메이션을 SwiftUI에 어울리게 개선

<br>
