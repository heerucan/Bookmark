# 서울시 책방 지도 서비스, 책갈피 🔖
### 서울시 공공데이터에서 받아온 책방 데이터를 토대로 책방의 위치와 상세 정보를 알려주는 앱  

🌐  [AppStore에서 책갈피 다운받기](https://apps.apple.com/kr/app/%EC%B1%85%EA%B0%88%ED%94%BC/id1645004700)

<br>


## 🔖 책갈피 기획 의도 소개

- 스스로 그동안 불편하다고 느낀 점들을 해결하기 위해 만들었다.

- 힐링을 하기 위한 장소로 서점에 자주 가는데, 대형서점 이외에도 독립서점과 같은 책방들의 정보가 SNS에 분산되어 있어 매번 검색해서 찾아가는 게 불편해 기존에 이런 페인포인트를 해소시켜줄 앱이 없다는 걸 알고 기획하게 되었다.

- 책을 읽다보면 마음에 와닿는 구절을 사진을 찍고, 후에 다시 찾아보는 경우가 있는데 그럴 때마다 구절 사진이 앨범 여기저기에 분산되어 있는 것이 불편했고, 친구에게 공유해줄 때도 앨범에서 찾는 시간이 오래 걸려 저장해서 모아볼 수 있으면 좋겠다고 생각해 만들게 되었다.

<br>


## 🔖 책갈피 소개

- 개발기간 **:** 2022.09.08 ~ 2022.09.30

- 출시날짜 **:** 2022.10.01

- 1인 기획 / 디자인 / 개발 (서울시 열린 데이터 광장 오픈API 및 자체 DB(Realm) 사용)
 
- Figma, Notion 사용

- iOS15 이상 대응


<br>

## 🔖 책갈피 화면 소개

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

## 🔖 책갈피 기술 스택 소개

- `MVC` `MVVM` : MVC를 기본 패턴으로 채택하고, 리팩 과정에서 MVVM으로 변경 진행 중

- `RealmSwift` : 서버가 없는 앱에서 자체DB로 채택

- `NMapsMap` : 지도로는 다양한 커스텀 기능을 제공하는 네이버 지도

- `Firebase - Crashlytics / Analytics` `FCM` : 파베를 통해 앱 충돌/ 앱 분석/ 푸시알림 기능 사용

- `Alamofire` : 서버통신 처리 시에 Alamofire에서 제공하는 라우터를 사용

- `SnapKit` : 코드베이스 UI 처리 시에 오토레이아웃에 편의를 제공하는 스냅킷 사용

- `Then` : 인스턴스 초기화 시에 가독성 좋은, 간결한 코드 작성을 위해 사용

- `RxSwift` `RxCocoa` : 반응형 및 비동기 처리에 용이, MVVM 패턴에 적합하다고 판단해 사용

<br>

## 🔖 책갈피 트러블슈팅
### 1. 글 작성 시 동일한 사진을 업로드 시 
**supplied item identifiers are not unique 이슈**

- 기존 사진 한 장에서 3장으로 기능 업데이트 하면서 `DiffableDataSource`를 사용하면서 발생한 이슈다.    
- `UICollectionViewDiffableDataSource`에 사용되는 Section Identifier Type과 Item Identifier Type을 각각 `Int`와 `UIImage?`로 타입을 지정한 경우에 처음 게시글에 A, B, C라는 사진을 업로드하고, 두 번째 게시글에 A, X, Y라는 사진을 업로드 시에 해당 이슈가 발생한다.
- 그에 대한 해결방법으로 Item Identifier Type에 적용할 `BookmarkImage`구조체를 새롭게 하나 만들어줬고, `Hashable` 프로토콜을 채택하고 각 아이템 별로 고유한 hash값을 갖도록 하기 위해 `UUID`를 구조체에 정의해서 이슈를 해결했다.

```swift
// MARK: - Item Identifier

struct BookmarkImage: Hashable {
    let id = UUID()
    let image: UIImage?
}
```

```swift
private var dataSource: UICollectionViewDiffableDataSource<Int, BookmarkImage>?
```

```swift
// MARK: - DiffableDataSource

extension BookmarkPhraseTableViewCell {
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<WriteCollectionViewCell, BookmarkImage> { cell, IndexPath, itemIdentifier in
            cell.setupData(image: itemIdentifier.image)
            cell.isUserInteractionEnabled = false
            cell.iconView.isHidden = true
        }

        dataSource = UICollectionViewDiffableDataSource(collectionView: imageCollectionView,
                                                        cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }

    func applySnapshot(_ items: [BookmarkImage]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, BookmarkImage>()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        dataSource?.apply(snapshot)
    }
}
```

<br>

### 2. Realm 스키마 설계 및 Repository 패턴을 통해 관리

- `Store` : 책방에 대한 모델
    - 책방 name과 추후 북마크 기능을 위해 Bool 값으로 bookmark를 받는다.
- `Record` : 게시물에 대한 모델
    - store : 어떤 책방에서의 게시글인지 Store 타입
    - title : 게시글 제목
    - category : 게시글의 카테고리 - 책 / 글귀
        - (추후 카테고리 항목이 추가될 수 있다는 것을 고려하지 못하고 2개의 카테고리기에 Bool 타입으로 설정했는데 기능 추가 시에 `마이그레이션` 필요)
    - createdAt : 작성한 날짜

```swift
// MARK: - Store

final class Store: Object {
    @Persisted(indexed: true) var name = ""
    @Persisted var bookmark: Bool
    
    @Persisted(primaryKey: true) var objectId: ObjectId
            
    convenience init(name: String, bookmark: Bool) {
        self.init()
        self.name = name
        self.bookmark = bookmark
    }
}

// MARK: - Record

final class Record: Object {
    @Persisted var store: Store?
    @Persisted var title: String?
    @Persisted var category: Bool
    @Persisted var createdAt = Date()
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(store: Store?, title: String?, category: Bool, createdAt: Date) {
        self.init()
        self.store = store
        self.title = title
        self.category = category
        self.createdAt = createdAt
    }
}
```

`BookmarkRepositoryType` 프로토콜을 만들어 `BookmarkRepository` 클래스에 채택해 빼놓은 프로토콜 메소드가 있는지 체크하도록 했다.    
`BookmarkRepository`는 `싱글톤 클래스`로 만들어서 렘 데이터를 오로지 해당 클래스를 통해서 관리할 수 있도록 구현했다.

```swift
// MARK: - BookmarkRepositoryType

protocol BookmarkRepositoryType {
    
    // 0. 책갈피탭 초기 정렬
    func fetchRecord(_ item: String) -> Results<Record>
    
    // 1. 글추가
    func addRecord(item: Record)
    
    // 2. 글수정
    func updateRecord(item: Any?)
    
    // 3. 글삭제
    func deleteRecord(record: Record, store: Store)
        
    // 4. 책방 북마크 초기 정렬
    func fetchBookmark() -> Results<Store>
}

// MARK: - BookmarkRepository

final class BookmarkRepository: BookmarkRepositoryType {
    static let shared = BookmarkRepository()
    private init() { }
    
    var realm = try! Realm()
    
    // MARK: - Record
    
    func fetchRecord() -> Results<Record> {
        return realm.objects(Record.self).sorted(byKeyPath: "createdAt", ascending: false)
    }
    
    func fetchRecord(_ item: String) -> Results<Record> {
        return realm.objects(Record.self).sorted(byKeyPath: "createdAt", ascending: false).filter("category == \(item)")
    }
    
    func addRecord(item: Record) {
        do {
            try realm.write {
                realm.add(item)
                print("Create Realm 성공!")
            }
        } catch let error {
            print(error)
        }
    }
    
    func updateRecord(item: Any?) {
        do {
            try realm.write {
                realm.create(Record.self, value: item as Any, update: .modified)
                print("Update Realm 성공!")
            }
        } catch let error {
            print(error)
        }
    }
    
    func deleteRecord(record: Record, store: Store) {
        do {
            try realm.write {
                FileManagerHelper.shared.removeImageFromDocument(fileName: "\(record.objectId).jpg")
                realm.delete(record)
                realm.delete(store)
                print("Delete Record, Store Realm 성공!")
            }
        } catch let error {
            print(error)
        }
    }
    
    // MARK: - Bookmark
    
    func fetchBookmark() -> Results<Store> {
        return realm.objects(Store.self).sorted(byKeyPath: "bookmark", ascending: true)
    }
}
```

<br>

### 3. NWNetworkMonitor를 통해 앱의 네트워크 연결 상태 체크

- 와이파이나 셀룰러에 연결되어 있지 않은 경우 또는 비행기 모드 등의 이유로 네트워크 연결상태가 불안정할 때 네이버 지도 상에 책방 좌표를 보여줄 수 없는 경우에 좋지 못한 사용자 경험을 줄 수 있다고 생각해 해당 기능을 추가    
- [영상으로 네트워크 연결 상태 처리 확인하기](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/fd239fe9-400b-4988-8030-021d29dc66e7/RPReplay_Final1671883961.mp4)

- iOS 12부터는 `NWNetworkMonitor` 라는 내부 라이브러리를 통해 네트워크 연결 상태를 체크 가능 `NetworkMonitor`라는 싱글톤 클래스를 생성해 `AppDelegate`에서 모니터링을 시작해 연결상태를 체크하고, `pathUpdateHandler`를 통해 연결상태가 변경될 시에 특정 동작을 주게끔 구현    
    
- `changeUIBytNetworkConnection` 메소드를 통해 파라미터로 `UIViewController`를 받아서 연결된 경우 탈출 클로저를 통해 화면전환을 진행할 수 있도록 구현하고, 연결되지 않은 경우에는 사용자에게 alert 창을 통해 2가지 옵션을 제공하는데
    - `재시도` : 네트워크 연결 상태 재확인
    - `종료` : 앱을 종료
        - 이 경우 앱이 부드럽게 꺼질 수 있게 해 사용자에게 강종과 같이 앱이 크래쉬가 나서 꺼지는 상황이 아님을 인지시킴

```swift
func changeUIBytNetworkConnection(vc: UIViewController, completion: @escaping (()->())) {
        if self.isConnected {
            completion()
            
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                let alert = UIAlertController(title: Matrix.Network.title,
                                              message: Matrix.Network.subtitle,
                                              preferredStyle: .alert)
                
                let closeAction = UIAlertAction(title: "종료", style: .default) { _ in
                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        exit(0)
                    }
                }
                
                let retryAction = UIAlertAction(title: Matrix.Network.button, style: .cancel) { _ in
                    self.changeUIBytNetworkConnection(vc: vc, completion: completion)
                }
                
                alert.addAction(closeAction)
                alert.addAction(retryAction)
                vc.transition(alert, .present)
            }
        }
    }
```

<br>

### 4. 푸시 알림 종류에 따라 화면전환을 다르게 처리

현재 책갈피에서는 2개의 푸시알림을 보내고 있는 중이다.    
- `willPresent` 메소드에서 앱이 현재 사용되고 있는 상황 (foreground) 에서 현재 보고 있는 뷰컨이 글쓰기뷰컨인 경우에는 어떤 알림도 주지 않도록 설정

```swift
// foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
        
        if viewController is WriteViewController {
            completionHandler([])
        } else {
            completionHandler([.sound, .banner, .list])
        }
   
```

- 알림 메시지를 선택 시에 `didReceive` 메소드를 통해 앱이 foreground/background인 상황에서 만일 해당 알림을 통해 전달 받은 userInfo의 키워드 값이 “`write`”인 경우에는 뷰컨이 HomeViewController, SettingViewController인 경우에 탭바의 1번 인덱스 뷰컨인 BookmarkViewController로 이동 후에 WriteViewController로 전환되도록 함

```swift
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
        
        let userInfo = response.notification.request.content.userInfo
        
        if userInfo[AnyHashable("write")] as? String == "write" {
            if viewController is HomeViewController {
                viewController.tabBarController?.selectedIndex = 1
                let writeViewController = WriteViewController()
                viewController.transition(writeViewController)
            }
            
            if viewController is SettingViewController {
                viewController.tabBarController?.selectedIndex = 1
                let writeViewController = WriteViewController()
                viewController.transition(writeViewController)
            }
            
        } else {
            viewController.tabBarController?.selectedIndex = 0
        }
    }
```

<br>

### 5. 책갈피 탭 메모리 누수로 앱 강종되는 이슈 해결하기

- 책갈피 탭에서 글/책 게시물 수를 합산해 상단에 보여줄 때 `NotificationCenter`를 통해 구현했는데 해당 부분에 불필요한 노티 호출이 발생하고 있었고, `removeObserver`를 해주지 않아 메모리 누수가 발생하는 문제가 있었다.
- 심각한 점은 앱을 출시해 앱스토어에 내놓은 상태에서 글 ↔ 책 탭을 탭할 시에 점점 앱의 속도가 느려지면서 어느 순간 메모리가 쌓이면 앱이 강종된다는 점이었다. 해당 이슈를 발견하지 못하고 앱 버전을 업데이트했고,추후 체크해보니 1기가 넘게 메모리 누수가 발생하고 있는 걸 확인해 해결했다.
        
<br>

### 6. 지도에 marker들이 겹치는 경우 처리해주기

맵에 marker를 어떻게 보여줘야 사용자들이 편하게 느낄지였다. 약 600개가 되는 marker를 화면에 보여주니 지도를 축소시에 환공포증이라는 부정적인 느낌을 줄 수 있는 UI가 그려졌다. (*실제로 이때 주변 피드백을 통해 개구리알, 도룡뇽알이라는 이야기를 들었다.)*

- marker의 모양을 수정하고,
- 축소, 확대 시에 marker가 어떻게 보여줘야 될 지 `isHideCollidedMarkers` 메소드를 사용해 해결했다.

```swift
marker.isHideCollidedMarkers = true
```

<br>

## 🔖 책갈피 개발 일지
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

<br>
<hr>

- 책갈피가 도서 카테고리 1위 하는 날까지 꾸준히 업데이트하자!
- 지금도 꾸준히 코드 품질 개선을 위해 리팩토링과 다양한 고민을 통한 기능 추가를 위해 달려!
