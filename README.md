# 책갈피
### 서울시 책방 지도 서비스, 책갈피 🔖
서울시 공공데이터에서 받아온 책방 데이터를 토대로 책방의 위치와 상세 정보를 알려주는 앱  

🌐  [AppStore 다운받기](https://apps.apple.com/kr/app/%EC%B1%85%EA%B0%88%ED%94%BC/id1645004700)

<br>
<hr>

#### 🗳 책갈피 기획 의도 소개

- 제가 그동안 불편하다고 느낀 점들을 해결하기 위해 만들었다.

- 힐링을 하기 위한 장소로 서점에 자주 가는데, 대형서점 이외에도 독립서점과 같은 책방들의 정보가 SNS에 분산되어 있어 매번 검색해서 찾아가는 게 불편해 기존에 이런 페인포인트를 해소시켜줄 앱이 없다는 걸 알고 기획하게 되었다.

- 책을 읽다보면 마음에 와닿는 구절을 사진을 찍고, 후에 다시 찾아보는 경우가 있는데 그럴 때마다 구절 사진이 앨범 여기저기에 분산되어 있는 것이 불편했고, 친구에게 공유해줄 때도 앨범에서 찾는 시간이 오래 걸려 저장해서 모아볼 수 있으면 좋겠다고 생각해 만들게 되었다.

<br>
<hr>

#### 🗳 책갈피 소개

- 개발기간 **:** 2022.09.08 ~ 2022.09.30

- 출시날짜 **:** 2022.10.01

- 1인 기획 / 디자인 / 개발 (서울시 열린 데이터 광장 오픈API 및 자체 DB(Realm) 사용)
 
- Figma, Notion 사용


<br>
<hr>


#### 🗳 책갈피 화면 소개

🌟 [책갈피 구현 화면 영상으로 보기](https://youtu.be/X2OyW07WnZc)

<br>

|홈|책방상세|책갈피(글)|책갈피(책)|검색|
|:-:|:-:|:-:|:-:|:-:|
|![3](https://user-images.githubusercontent.com/63235947/208466881-96c2b31e-ad21-40d1-9df2-f61e0e471731.png)|![4](https://user-images.githubusercontent.com/63235947/208466908-9174c8f5-331a-4754-bfd0-83193f5705d9.png)|![5](https://user-images.githubusercontent.com/63235947/208466914-ace9ed30-1737-4ca1-94f6-d53039add86d.png)|![6](https://user-images.githubusercontent.com/63235947/208466921-95b0633e-7f89-4f88-81d4-f5d9ba677bfc.png)|![7](https://user-images.githubusercontent.com/63235947/208466927-351318b2-4643-434d-b906-dc19b0a4f8b0.png)|

<br>

- 서울시 열린 데이터 광장 오픈 API를 사용해 사용자 위치 기반 책방 위치 제공

- 새책방 / 헌책방 필터 기능 제공

- 책방 검색

- 책방 상세 정보 (책방 SNS 링크 연결, 바로 전화 걸기, 책방 위치 외부맵으로 이동) 공유

- 책방 이름과 함께 글귀 및 책 사진 기록

- 인스타그램 및 외부 공유

<br>
<hr>

#### 🗳 책갈피 기술 스택 소개
- `RealmSwift`

- `NMapsMap`

- `Firebase - Crashlytics / Analytics`

- `Alamofire`

- `SnapKit`

- `Then`

- `RxSwift` `RxCocoa`

<br>
<hr>

#### 🗳 책갈피 개발 일지
- `Git` 
  - [눙물 줄줄 나는 Couldn’t load project](https://huree-can-do-it.notion.site/gitignore-feat-Couldn-t-load-Project-784231d4681043bdad3d42839935e1a7)
  
- `Feature`
  - [다채로운 네이버 지도 커스터마이징](https://huree-can-do-it.notion.site/1-c327aeb5b29a4889900b410e71dbb208)
  
- `CI/CD`
  - [fastlane을 사용한 자동배포화 적용 삽질기 *testflight에만 적용](https://huree-can-do-it.notion.site/Fastlane-3f733e4a32a5480db76c91fb594a9695)
  
- `Refactor`
  - [URLRequestConvertible을 사용해서 Network 통신 코드 개선하기](https://huree-can-do-it.notion.site/URLRequestConvertible-e118bbf9dd9640a59db13a726ac9779a)
  - [설정뷰에 처음 시도해본 MVVM + Compositional + DiffableDataSource](https://huree-can-do-it.notion.site/MVVM-a050808dee564704b9f118c25fb6eb1a)
  - [설정뷰 Rx 적용해서 개선하기 feat. 멘토님 피드백 반영](https://huree-can-do-it.notion.site/2-Rx-MVVM-70cc157972ff4dc28447a1a342b3abca)
  
- `BugFix`
  - [1기가 넘게 줄줄 새고 있던 메모리 누수 해결](https://huree-can-do-it.notion.site/ccad55aa67be4eb5a79bc6dfb93243c9)

<br>
<hr>

- 책갈피가 도서 카테고리 1위 하는 날까지 꾸준히 업데이트하자!
- 지금도 꾸준히 코드 품질 개선을 위해 리팩토링과 다양한 고민을 통한 기능 추가를 위해 달려!
