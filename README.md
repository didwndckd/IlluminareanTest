# 일루미나리안 코딩테스트

### Setting

GitHub OAuth를 사용하기 위한 `client_id`와 `client_secret`값이 필요합니다.

Public 

함께 첨부한 `Constant+Secret.swift` 파일을 프로젝트 내 `IlluminareanTest/Constant` 경로에 추가해 주세요.

## Protocol

### LoadingView

로딩을 실행할 뷰 프로토콜

- 요구사항

  ``` swift
  // 로딩 시작
  func startLoading()
  // 로딩 종료
  func stopLoading()
  ```

## Extension

### Error

- ``` swift
  var message: String 
  ```

  - 자체 `APIError` 타입인 경우 내부  `message`  프로퍼티를 반환 하고 아닌경우 `localizedDescription`을 반환

- ``` swift
  var code: Int
  ```

  -  `NSError`로 변환하여 `code` 값 반환

### Publisher

- ``` swift
  func withUnretained<T: AnyObject>(_ object: T) -> Publishers.CompactMap<Self, (T, Self.Output)>
  ```

  - 전달 받은 객체를 약한 참조 하여 다음 스트림으로 넘겨주는 함수

- ``` swift
  func sink<T: AnyObject>(with object: T, receiveCompletion: ((T, Subscribers.Completion<Self.Failure>) -> Void)? = nil, receiveValue: ((T, Self.Output) -> Void)? = nil) -> AnyCancellable
  ```

  - 전달받은 객체 약한 참조 하여 `sink` 구독

### UIView

- ``` swift
  func addSubviews(_ views: UIView...)
  ```

  - 다수의 뷰들을 한번에 `addSubview` 하기 위한 함수


### UIControl

- ``` swift
  func eventPublisher(for event: Event) -> EventPublisher
  ```

  - 이벤트 타입을 받아서 해당 이벤트가 발생하면 `UIControl` 객체를 방출하는 퍼블리셔 반환

### UIViewController

- ``` swift
  func presentAlert(_ model: SystemAlert)
  ```

  -  자체 정의한 `SystemAlert` 데이터를 전달받아 `UIAlertController`를 `present` 하는 함수

### UIAlertController

- ``` swift
  convenience init(model alert: SystemAlert)
  ```

  - 자체 정의한 `SystemAlert` 데이터를 전달받아 `UIAlertController`를 생성하는 편의 생성자

- ``` swift
  private func setupActions(_ actions: [SystemAlertAction])
  ```

  - 자체 정의한 `SystemAlertAction` 배열을 전달받아 자신의 액션에 추가하는 내부 함수

### UIActivityIndicatorView

- 기본 로딩 뷰로 사용하기 위해 `LoadingView` 프로토콜 채택

- ``` swift
  func startLoading()
  ```

  -  `LoadingView` 프로토콜의 필수 구현 요구사항으로 로딩 시작 함수

- ``` swift
  func stopLoading()
  ```

  - `LoadingView` 프로토콜의 필수 구현 요구사항으로 로딩 종료 함수

### UITableView

- ``` swift
  func register<T: UITableViewCell>(_: T.Type) where T: ReusableView
  ```

  - 셀 등록을 위한 편의 함수

  -  `ReusableView` 프로토콜을 채택해야만 사용 가능

  - `ReusableView` 프로토콜에 정의된 `defaultReuseIdentifier`를 사용하여 셀 등록, 호출부에서는 타입 정보만 전달하면 됩니다

    

- ``` swift
  func dequeueReusableCell<T: UITableViewCell>(_: T.Type, for indexPath: IndexPath) -> T where T: ReusableView
  ```

  - 셀을 `dequeueReusableCell`을 위한 편의 함수

  -  `ReusableView` 프로토콜을 채택해야만 사용 가능

  - `ReusableView` 프로토콜에 정의된 `defaultReuseIdentifier`를 사용하여 `dequeueReusableCell` 하고 타입 캐스팅 하여 반환, 호출부에서는 타입 정보와 `indexPath`만 전달하면됩니다

### UIImageView

- ``` swift
  func setImage(_ url: URL?, placeholder: UIImage? = nil)
  ```

  - `KingFisher`를 사용하여 자신의 이미지 세팅

- ``` swift
  func setImage(_ urlString: String, placeholder: UIImage? = nil)
  ```

  - 위에 구현된 `setImage` 함수를 사용하여 `String` 타입 url을 받아 이미지를 세팅하는 함수

  
