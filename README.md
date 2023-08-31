# RIBs-todo

# 앱 소개

RIBs 를 적용한 todo 앱입니다. 

Tuist 를 이용한 모듈화를 진행했습니다.

# RIBs 를 선택한 이유

## 옵션들

### MVC


![Untitled (29)](https://github.com/godo129/RIBs-todo/assets/76652929/f01dc66d-01a3-48b6-b960-a432e24fdff9)


- MVC 를 사용하면 ViewController 의 크기 비대해지는 문제가 생기게 되고, 논리적인 부분이 너무 걸쳐 있어서 관리하기도 어렵고 중복된 코드가 발생하는 경우가 많았습니다.
- 물론 크기가 작은 프로젝트에서는 MVC 를 사용해도 괜찮지만 MVC 는 View 와 이를 보여주는 로직이 존재하는 한 적합한 패턴이라고 생각하다고 느끼진 못 했습니다.

### MVVM


![Untitled (30)](https://github.com/godo129/RIBs-todo/assets/76652929/b8534039-769c-4948-a1eb-351a6d31f56a)


- MVVM 은 ViewController 에서의 로직에 해당하는 부분을 ViewModel 에 분리한 형태, 그러나 이것은 이렇게 써야 한다라는 특별하게 정의된 패턴이 없다보니 개발자마다 다들 자신만의 방식으로 만들다보니 통합하기 어려운 모습이 보였습니다.
- 그러다보니 많은 사람들이 코드를 작성할 때 어떤형식으로 만들지에 대한 약속을 해야하고 그렇지 않으면 관리하기 힘든 모습을 보일 수 있다고 생각하게 되었습니다.

### TCA


![Untitled (31)](https://github.com/godo129/RIBs-todo/assets/76652929/a1c20eb1-18a6-40a0-b3e0-86377c5eef27)


- TCA는 ViewStore 을 이용해서 뷰의 Action 에 따라 Effect 가 발생하게 되고 이에 따라서 State 가 변경 되는 형태로 구성되어 있습니다. 찾아보니 Flux 패턴이 있던데 이와 비슷한 방식인 것 같습니다.


<img width="604" alt="Untitled (32)" src="https://github.com/godo129/RIBs-todo/assets/76652929/659d1f38-e115-4555-9f60-c3a8b86cfc3c">


  위는 제가 TCA 를 적용해서 만든 코드입니다. 
    
- 프레임워크여서 이미 정해진 규칙이 있기 때문에 MVVM 보다 더 일관적으로 코드를 유지할 수 있다고 생각하게 되었습니다. 하지만


![Untitled (33)](https://github.com/godo129/RIBs-todo/assets/76652929/939c060c-f92f-4b98-af9f-6ad146c18796)


ViewStore 이 ObservableObject 라는 프로토콜을 채택하고 있고 이것은 Combine 와 관련이 있는 부분이기 때문에 RxSwift 를 사용하는 프로젝트에서는 TCA 를 적용하면 조금은 생각을 해봐야 될 것 같다고 생각하게 되었습니다. 

### RIBs


![Untitled (34)](https://github.com/godo129/RIBs-todo/assets/76652929/b064918f-56c6-43d1-b6da-c5a67624e81d)



- RIBs 는 Router, Interactor 및 Builder 의 약자로써 Builder 은 RIB 들을 만드는 것을 뜻하고, Router 은 뷰간의 전환을 Interactor 은 View 에서 발생한  이벤트들을 처리하는 부분을 뜻합니다. 그리고 Presenter 와 View 는 각각 ViewModel 과 ViewController 의 역할을 할 수 있는 부부입니다. Component 는 의존선 부분이라고 보면 됩니다.
- 이 RIBs 또한 프레임워크기 때문에 정해진 패턴이 존재합니다. 그리고 Uber 에서 만든 cross-platform 모바일 아키텍쳐 프레임워크 이기 때문에 다른 모바일 기기에서도 이 패턴을 사용할 수 있다고 합니다. 상당히 많은 회사에서 RIBs 로 전환을 하는 아티클이나 글들이 많아서 자료가 풍부하다고 느꼈습니다.
- 하지만 기본적으로 Builder, Router, Ineteractor, View, Component 가 무조건 있어야 해서 하나의 뷰를 만드는 데 거의 반강제적으로 4개의 파일이 생겨서 관리하기 매우 어려울 수 있는 단점이 있습니다. 그리고 UIKit 을 기반으로 만들어졌기 때문에 SwiftUI 에선 사용하는 게 큰 이점이 없다고 느꼈습니다.


<img width="324" alt="Untitled (35)" src="https://github.com/godo129/RIBs-todo/assets/76652929/977c8010-b04c-4e18-9c25-d39abfd633f9">



## 그래서 RIBs 를 선택한 이유

기본적으로 선택지는 4가지가 있었습니다. 그 중 MVC 는 우선적으로 관리측면과 확장성에서 매우 불리하다고 느껴서 제외하였습니다. 그리고 MVVM 은  MVVM-C 과 CleanArchitecture 을 적용한 프로젝트를 진행해보았고, MVVM 의 문제점인 개발자마다 스타이리 달라서 코드의 일관성을 유지하기 어려운 문제점 또 MVVM 에서 TCA 나 RIBs 로 마이그레이션을 시도하는 기업들의 아티클을 보고 MVVM 을 선택지에 제외하였습니다.  

그래서 최종적으로 TCA 와 RIBs 라는 두 가지의 선택지가 남아 있었습니다. 

TCA 는 SwiftUI 를 사용한 프로젝트를 맡았을 때 MVVM 과 MVC 가 혼합되어있어서 프로젝트가 진행됨에 있어서 관리를 할 수 없게 되어서 찾다보니 SwiftUI 에서는 @State 라는 Binding 기본적으로 제공하는 특성 때문에 MVVM 을 지양하자는 아티클을 보았고 거기서 추천하는 방식으로 TCA 라는 프레임워크를 사용하는 것이였습니다. 그래서 TCA 를 적용해서 앱 구조를 다시 잡은 적이 있습니다. 하지만 뷰의 전환을 관리하는 부분이 존재하지 않아서 SwiftUI 에서 가장 큰 문제인 뷰의 전환을 관리할 수 있는 방법이 iOS16 이후에 NavigationStack 이 나왔지만 그 이전엔 사실상 존재하지 않아서 라이브러리를 이용하던가 자신이 직접 뷰의 전환을 관리하는 객체를 만들어야 하는 단점을 해결할 수 있지 않아서 큰 어려움을 겪었고 저는 개인적으로 이를 관리할 수 있는 객체를 만들어서 해결했습니다. 

UIKit을 이용할 때도  MVVM 과 같이 따로 관리할 수 있는 방법을 찾아야 하는 문제점이 있다는 것을 알게 되었고 RIBs 를 이용하면 Router 이 있기 때문에 이를 이용해서 이러한 뷰의 전환을 관리할 수 있는 문제점을 해결할 수 있음을 알게 되어서 RIBs 를 사용하기로 하였습니다. 

# Tuist 를 이용한 프로젝트 관리

협업시에 .pbxproj 에 충돌이 일어나게 되는 데 이 부분을 Tuist 를 이용하면 줄일 수 있고, 


![Untitled (36)](https://github.com/godo129/RIBs-todo/assets/76652929/64e9dddf-e74f-4c6d-bc9c-eab734f035e0)



외부 라이브러리 사용시 Tuist 를 이용하면 버전 관리하기도 쉽고 모듈간의 의존성을 이미지로 만들어주어서 의존선들을 파악하기 쉬운 장점을 가지고 있어서 사용하였습니다. 


![Untitled (37)](https://github.com/godo129/RIBs-todo/assets/76652929/946488b5-df63-462d-b899-242eaa654d28)




# 추상화를 적용한 Provider 생성

MoyaProvider 을 참고하여 Network 통신하는 코드와 Local 에 데이터를 저장하는 코드를 만들었습니다. 

## NetworkProvider

- RemoteTargetType

```swift
// 정의 
public enum HTTPMethod: String  {
    case get = "GET"
    case post = "POST"
}

public protocol RemoteTargetType {
    var base: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var data: Encodable? { get }
    var headers: [String: String]? { get }
    var paramters: [String: String]? { get }
    func asRequest() -> URLRequest?
}

extension RemoteTargetType {
    public func asRequest() -> URLRequest? {
        guard var urlComponents = URLComponents(string: base + path) else {
            return nil
        }
        if let queries = paramters {
            let queryItems = queries.map { URLQueryItem(name: $0.key, value: $0.value) }
            urlComponents.queryItems = queryItems
        }
        guard let url = urlComponents.url else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = headers
        if let enocodedData = try? data?.toJson() {
            urlRequest.httpBody = enocodedData
        }
        print("-------")
        print("🚀🚀🚀🚀")
        print("Request")
        print(urlRequest.description)
        print("Query Paramters: \(urlComponents.queryItems ?? [])")
        return urlRequest
    }
}

extension Encodable {
    func toJson() throws -> Data {
        do {
            let encodedData = try JSONEncoder().encode(self)
            return encodedData
        } catch {
            print(error)
            throw error
        }
    }
}

extension Data {
    func toObject<T: Decodable>(_ type: T.Type) throws -> T {
        do {
            let docodedData = try JSONDecoder().decode(type, from: self)
            return docodedData
        } catch {
            print(error)
            throw error
        }
    }
}
```

- NetworkProvider

```swift

public protocol NetworkProviderProtocol {
    func request<T: RemoteTargetType>(_ type: T) async throws -> Data
}

public struct NetworkProvider<T: RemoteTargetType>: NetworkProviderProtocol {
    
    private enum NetworkProviderError: LocalizedError {
        case urlRequestDoesntExist
        case urlResponseDeosntExist
        case responseFailed
        case responseDataDeosntExist
    }
    
    public init() {}
    
    public func request<T: RemoteTargetType>(_ type: T) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            guard let urlReqeust = type.asRequest() else {
                continuation.resume(throwing: NetworkProviderError.urlRequestDoesntExist)
                return
            }
            let task = URLSession.shared.dataTask(with: urlReqeust) { data, response, error in
                print("--------")
                print("🪂🪂🪂🪂")
                print("Response")
                print(urlReqeust.description)
                if let error {
                    print("error: \(error)")
                    continuation.resume(throwing: error)
                    return
                }
                guard let responseStatus = response as? HTTPURLResponse else {
                    continuation.resume(throwing: NetworkProviderError.urlResponseDeosntExist)
                    return
                }
                print("reponseStatusCode: \(responseStatus.statusCode)")
                if responseStatus.statusCode != 200 {
                    continuation.resume(throwing: NetworkProviderError.responseFailed)
                    return
                }
                guard let data else {
                    continuation.resume(throwing: NetworkProviderError.responseDataDeosntExist)
                    return
                }
                print("responseData: \(String(data: data, encoding: .utf8) ?? "") - \(data)")
                
                continuation.resume(returning: data)
            }
            task.resume()
        }
    }
}
```

## LocalProvider

- LocalStorable

```swift
public protocol LocalStorable {
    var identifier: String { get }
    var encodeType: Encodable.Type? { get }
    var decodeType: Decodable.Type? { get }
    var enocodeData: Encodable? { get }
}
```

- LocalProviderProtocol

```swift

public protocol LocalProviderProtocol {
    func create<T: LocalStorable>(_ type: T) throws
    func read<T: LocalStorable>(_ type: T) throws -> Decodable
    func delete<T: LocalStorable>(_ type: T) throws
}
```

결과 좀 더 깔끔하고 재사용성 높은 코드를 만들 수 있었습니다. 

# And, NeedleKit

## NeedleKit

레이아웃을 쉽게 적용할 수 있는 SnapKit 이라는 라이브러리를 참고하여 NeedleKit 이라는 모듈을 만들어 적용했습니다. 비슷한 인터페이스를 가지도록 설계했습니다. 

차이점이 있다면 SnapKit 이라는 라이브러리는 NSLayoutConstraint 를 생성자를 이용해서 만들 었다면 저는 NSLayoutAnchor 을 이용해서 NSLayoutConstraint 를 만든 것이 다른 점입니다. 

```swift
extension UIView {

    public var ndl: ConstraintDSL {
       return ConstraintDSL(view: self)
    }
    
    @available(*, deprecated, renamed:"ndl.makeConstraints(_:)")
    public func ndl_makeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        self.ndl.makeConstraints(closure)
    }

}

public struct ConstraintDSL {
    
    private let view: UIView

    internal init(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view = view
    }
    
    public func makeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        return ConstraintMaker.makeConstraint(view: self.view, closure: closure)
    }
}

internal enum AnchorAttribute {
    case top
    case bottom
    case left
    case right
    case width
    case heigth
    case centerX
    case CenterY
    case firstBaseLine
    case lastBaseLine
    case leading
    case trailing
    case edges
    case horizontal
    case vertical
}

public class ConstraintMaker {

... 

internal static func makeConstraint(
        view: UIView,
        closure: (_ make: ConstraintMaker) -> Void
    ) {
		let constraints = prepareConstraints(view, closure: closure)
    for constraint in constraints {
					...
		}

}

internal static func prepareConstraints(_ view: UIView, closure: (_ make: ConstraintMaker) -> Void) -> [Constraint] {
        let constraintMaker = ConstraintMaker(view)
        closure(constraintMaker)
        var constraints: [Constraint] = []
        for anchor in constraintMaker.anchors {
            if let to = anchor.to {
                let constraint = Constraint(type: anchor.type, from: constraintMaker.view, to: to, constant: anchor.constant, needSafeAreaLayout: anchor.needSafeAreaLayoutGuide)
                constraints.append(constraint)
            } else if anchor.type == .width || anchor.type == .heigth {
                let constraint = Constraint(type: anchor.type, from: constraintMaker.view, to: empthyView, constant: anchor.constant, needSafeAreaLayout: anchor.needSafeAreaLayoutGuide)
                constraints.append(constraint)
            }
        }
        return constraints
    }
    
    private func anchorAppend(_ constraintAnchor: ConstraintAnchor) -> ConstraintAnchor {
        self.anchors.append(constraintAnchor)
        return constraintAnchor
    }
}

public class ConstraintAnchor {

    internal let type: AnchorAttribute
    internal var needSafeAreaLayoutGuide: Bool = false
    internal var to: UIView?
    internal var constant: CGFloat = 0.0
    
    internal init(type: AnchorAttribute) {
        self.type = type
    }

    @discardableResult
    public func equalTo(_ view: UIView, needSafeAreaLayoutGuide: Bool = false) -> ConstraintRelate {
        self.needSafeAreaLayoutGuide = needSafeAreaLayoutGuide
        self.to = view
        return ConstraintRelate(constraintAnchor: self)
    }
    
    @discardableResult
    public func equalTo(_ constant: CGFloat) -> ConstraintRelate {
        self.constant = constant
        return ConstraintRelate(constraintAnchor: self)
    }
}

public class ConstraintRelate {
    
    private let constraintAnchor: ConstraintAnchor
    
    internal init(constraintAnchor: ConstraintAnchor) {
        self.constraintAnchor = constraintAnchor
    }
    
    @discardableResult
    public func constant(_ constant: CGFloat) -> ConstraintRelate {
        self.constraintAnchor.constant += constant
        return self
    }
}
```


<img width="506" alt="Untitled (38)" src="https://github.com/godo129/RIBs-todo/assets/76652929/5c05c460-9b06-4d10-922c-4f0dfae9b53a">




## And

인스턴스 정의를 쉽게 할 수 있는 Then 라이브러리를 참고하여 And 라는 모듈을 만들어 보았습니다. 

```swift
public protocol And {}

extension And where Self: AnyObject {
    @inlinable
    public func and(_ adjust: ((Self) throws -> Void)) rethrows -> Self {
        try adjust(self)
        return self
    }
}

extension NSObject: And {}
```


<img width="651" alt="Untitled (39)" src="https://github.com/godo129/RIBs-todo/assets/76652929/56b8a9c0-675f-47fa-a39f-f207a5959b61">



결과적으로 각각의 프레임워크가 어떻게 구성 되는 지 알게 되었고, 접근 제어자에 대해 이해할 수 있게 되었습니다.  

# Module 화

- 네트워크 통신을 담당하는 NetworkProvider 와 Plist, UserDefaults, NsCahce 를 관리할 수 있는 LocalProvider 그리고 레이아웃 설정을 쉽게 해주는 NideelKit, 인스턴스 정의를 쉽게 해주는 And 으로 모듈을 나눴습니다.
- 모듈화를 한 뒤 각각의 모듈들의 UnitTest 를 진행할 수 있어서 테스트 가능하고, 재사용 가능하도록 만들었습니다.


![Untitled (40)](https://github.com/godo129/RIBs-todo/assets/76652929/cc41fe00-4b4f-4e25-ac6a-6f7b6c89a6f9)


<img width="441" alt="Untitled (41)" src="https://github.com/godo129/RIBs-todo/assets/76652929/97162499-b969-4c09-8b29-cf67482b3d36">



# **환경별 Build 세팅**

- TodoApp-Dog 와 TodoApp-Cat 이라는 두 가지의 Build 환경을 만들었습니다.
    

<img width="648" alt="Untitled (42)" src="https://github.com/godo129/RIBs-todo/assets/76652929/da8b7aca-e6e2-4e17-a2aa-580ef6a4b5a1">



<img width="454" alt="Untitled (45)" src="https://github.com/godo129/RIBs-todo/assets/76652929/bac99935-cbf7-4736-8844-b7fbbd619671">


    
- 두 환경을 구분할 수 있도록 설정을 해주었습니다.


<img width="528" alt="Untitled (43)" src="https://github.com/godo129/RIBs-todo/assets/76652929/f222250e-89df-4c85-8028-ad3ecdc37b7f">


<img width="512" alt="Untitled (44)" src="https://github.com/godo129/RIBs-todo/assets/76652929/bd0dbcf1-eb1b-4f0a-80e9-458371ac8b3b">



- 두 빌드 환경에 따라 서로 다른 API 콜을 진행할 수 있도록 만들었고 각각 개와 고양이 사진이 나오도록 하였습니다.
  
  
![Simulator Screen Recording - iPhone 14 Pro Max - 2023-08-31 at 19 56 44](https://github.com/godo129/RIBs-todo/assets/76652929/43e3abe1-a7d2-44fc-94bb-448bd01575ae)


