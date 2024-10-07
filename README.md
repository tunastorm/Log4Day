
# Log4Day

<br>

### | 서비스 소개

- 매일의 추억을 지도와 네컷사진으로 기록할 수 있는 어플리케이션
- 카테고리별 로그(일기) 분류 및 네컷사진 이미지 갤러리 저장 지원


### | [앱스토어](http://apps.apple.com/kr/app/log4day-%EB%84%A4-%EC%BB%B7-%EC%82%AC%EC%A7%84-%EC%86%8D-%EC%98%A4%EB%8A%98-%ED%95%98%EB%A3%A8/id6736357381)   



![title](https://img.notionusercontent.com/s3/prod-files-secure%2Fda5d8819-a24c-4673-97de-9c024056b4fb%2F9015a9b2-34fe-48f1-89b4-35414dfa4c5f%2FappstoreScreenshot.jpeg/size/w=20?exp=1728302975&sig=CPCz5aFIJU8E73PUcqkSnbZq9XXggRPGhjeEW6XWBoU)   

### | 스크린샷
![title](https://img.notionusercontent.com/s3/prod-files-secure%2Fda5d8819-a24c-4673-97de-9c024056b4fb%2Ff91599ec-de89-4dcc-9ca1-e0b551d7972b%2FApple_iPhone_11_Pro_Max_Screenshot_All.png/size/w=2000?exp=1728301394&sig=IYB76JLQ3GUW423d5HMC1o5s82A3XxlCKwTCYfrRwNw)   

<br>


프로젝트 정보
-
<br>

### | 개발기간 
 2024.09.12 ~ 2024.10.08

### | 개발인원
클라이언트 1명

### | 최소 지원 버전
iOS 15.0 이상

<br>


주요 기능
-

<br>

### | 방문장소 검색

### | 방문장소 및 동선 표기 기능

### | 방문장소 이미지 등록

### | 로그(일기) 조회 / 등록 / 수정 / 삭제

### | 카테고리 추가 / 삭제

### | 네컷사진 갤러리 저장


<br>

기술 스택
- 

<br>

### | Architecture & Design Pattern

* MVVM, Input-Output
* Singleton, Router

### | Swift Libraries

* SwiftUI
* Combine
* UIKit

### | Commercial Library & API
* Naver Maps API V3
* Naver Open API Search (지역)

### | OpenSource Libraries

* Alamofire
* BottomSheet
* RealmSwift
* SnapKit
* SwiftUIX


<br>

구현 사항 - 포폴에 작성한 개념도 활용
-

<br>

### | 프로젝트 구성도 

### | 장소 검색 후 방문 장소 / 경로 표기 로직 도표

### | 이미지 crop

### | Custom InfinityCarouselView + Image Saving 

### | Custom SideBar

### | UIViewControllerRepresentable

### | UIHostingController

<br>

트러블 슈팅
-

<br>

 ### | 지도 Representable 객체 비동기 처리
  -  선택된 마커/장소에 대한 이벤트 처리가 1~2초가량 지연되는 이슈
  -  사용자가 선택한 장소의 위치를 입력받는 프로퍼티에 view의 변경이 없는 viewModel의 변경은 예측되지 않은 동작을 일으킬 수 있다는 보라색 경고 발생
  - updateView 메서드의 로직을 Main큐에서 비동기처리하도록 개선
  - 마커 선택 및 장소 셀 선택시 즉각적인 반응 

 ### | 이미지 다운 샘플링
- 개발단계에서는 원본 이미지를 그대로 사용하므로 지도뷰에서 장시간 또는 대량의 작업이 일어날 경우 메모리에 과도한 부하발생 가능성
- WWDC에서 SwiftUI에서 제공하는 Image의 resizable이나 UIGraphicsImageRenderer보다 더 효율적인 방법으로 소개된ImageIO를 사용한 다운샘플링 구현
- 전 후 성능비교
 
<br>

회고
-

<br>

### | 성취점

* SwiftUI에서 MVVM 아키텍처 구현
* 비용효율적으로 최소 사양을 iOS15까지 대응하기 위해 버전별 분기처리 대신 iOS15를 기준으로 코드 작성
* View에 사용되는 Model 타입별로 viewModel 구현, View가 변경되어도 동일 기능에 대한 코드 재사용성 확보
* Naver Maps API SDK를

### | 개선사항
* 생산성을 위해 선택한 단일 viewModel이 동시에 여러 뷰 객체와 이벤트를 주고 받으면서 뷰 객체들간의 이벤트 전파를 중개하고 있는 지금의 구조가 과연 적절한 구조일까.
* 커스텀으로 구현한 무한 페이지네이션 뷰의 딱딱한 스크롤 애니메이션을 SwiftUI에 어울리게 개선
* 핵심 기능의 사용이 어렵다는 평가가 있는데 기획의 수정으로 풀어야 할까, 튜토리얼로 대응해줘야할까.  

<br>
