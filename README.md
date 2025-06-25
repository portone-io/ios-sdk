# PortOne SDK for iOS

iOS 환경에서 포트원 V2 결제 시스템에 연동하기 위한 SDK입니다.

## 요구사항

- iOS 14.0 이상
- Swift 6.0 이상
- Xcode 15.0 이상

## 기술 지원

- tech.support@portone.io

## 설치

### Swift Package Manager

1. Xcode에서 프로젝트를 열고 **File > Add Package Dependencies**를 선택합니다.
2. 패키지 URL에 다음을 입력합니다:
   ```
   https://github.com/portone-io/ios-sdk.git
   ```
3. 버전 규칙을 선택하고 **Add Package**를 클릭합니다.

### Package.swift

`Package.swift` 파일에 다음 의존성을 추가합니다:

```swift
dependencies: [
    .package(url: "https://github.com/portone-io/ios-sdk.git", from: "<버전>")
]
```

## 설정

### Info.plist 설정

앱의 `Info.plist`에 다음 설정을 추가해야 합니다.
자세한 내용은 [SwiftExample/SwiftExample/Info.plist](SwiftExample/SwiftExample/Info.plist)에서 확인할 수 있습니다.

1. **URL Scheme 등록** (결제 완료 후 앱으로 돌아오기 위함)
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
       <dict>
           <key>CFBundleURLSchemes</key>
           <array>
               <string>your-app-scheme</string>
           </array>
       </dict>
   </array>
   ```

2. **외부 결제 앱 스킴 등록** (한국 결제 앱 연동을 위함)
   ```xml
   <key>LSApplicationQueriesSchemes</key>
   <array>
       <string>kakaotalk</string>
       <string>naverpay</string>
       <string>ispmobile</string>
       <string>shinhan-sr-ansimclick</string>
       <!-- ... -->
   </array>
   ```

## 사용법

전체 사용 예제는 [SwiftExample/SwiftExample/ContentView.swift](SwiftExample/SwiftExample/ContentView.swift)에서 확인할 수 있습니다.

### 결제

```swift
import SwiftUI
import PortOneSdk

struct PaymentView: View {
    @State private var showPaymentSheet = false
    
    var body: some View {
        Button("결제하기") {
            showPaymentSheet = true
        }
        .sheet(isPresented: $showPaymentSheet) {
            let paymentId = UUID().uuidString.replacingOccurrences(of: "-", with: "")
            
            PaymentWebView(
                data: [
                    "storeId": "your-store-id",
                    "channelKey": "your-channel-key",
                    "paymentId": paymentId,
                    "orderName": "주문명",
                    "totalAmount": 1000,
                    "currency": "KRW",
                    "payMethod": "CARD",
                    "appScheme": "your-app-scheme://"
                ],
                onCompletion: { result in
                    switch result {
                    case .success(let payment):
                        print("결제 성공: \(payment)")
                    case .failure(let error):
                        print("결제 실패: \(error)")
                    }
                    showPaymentSheet = false
                }
            )
        }
    }
}
```

### 빌링키 발급

```swift
import SwiftUI
import PortOneSdk

struct BillingKeyView: View {
    @State private var showIssueBillingKeySheet = false
    
    var body: some View {
        Button("빌링키 발급") {
            showIssueBillingKeySheet = true
        }
        .sheet(isPresented: $showIssueBillingKeySheet) {
            IssueBillingKeyWebView(
                data: [
                    "storeId": "your-store-id",
                    "channelKey": "your-channel-key",
                    "issueName": "빌링키 발급 테스트",
                    "billingKeyMethod": "CARD",
                    "appScheme": "your-app-scheme://"
                ],
                onCompletion: { result in
                    switch result {
                    case .success(let billingKey):
                        print("빌링키 발급 성공: \(billingKey)")
                    case .failure(let error):
                        print("빌링키 발급 실패: \(error)")
                    }
                    showIssueBillingKeySheet = false
                }
            )
        }
    }
}
```

### 본인인증

```swift
import SwiftUI
import PortOneSdk

struct IdentityVerificationView: View {
    @State private var showIdentityVerificationSheet = false
    
    var body: some View {
        Button("본인인증") {
            showIdentityVerificationSheet = true
        }
        .sheet(isPresented: $showIdentityVerificationSheet) {
            let identityVerificationId = UUID().uuidString.replacingOccurrences(of: "-", with: "")
            
            IdentityVerificationWebView(
                data: [
                    "storeId": "your-store-id",
                    "channelKey": "your-channel-key",
                    "identityVerificationId": identityVerificationId
                ],
                onCompletion: { result in
                    switch result {
                    case .success(let verification):
                        print("본인인증 성공: \(verification)")
                    case .failure(let error):
                        print("본인인증 실패: \(error)")
                    }
                    showIdentityVerificationSheet = false
                }
            )
        }
    }
}
```


## 파라미터 레퍼런스

결제, 빌링키 발급, 본인인증의 상세 파라미터는 [포트원 개발자 문서](https://developers.portone.io/sdk/ko/v2-sdk/readme)를 참조하세요.
단, `redirectUrl` 파라미터의 경우 결제 결과를 받아오기 위해 SDK가 자동 입력하므로 무시됩니다.

## 예제 프로젝트

`SwiftExample` 디렉토리에서 SDK 사용 예제를 확인할 수 있습니다:

```bash
cd SwiftExample
open SwiftExample.xcodeproj
```

예제를 실행하기 전에 `ContentView.swift`에서 실제 `storeId`와 `channelKey`로 변경해야 합니다.

## 라이선스

이 프로젝트는 Apache License 2.0과 MIT License의 듀얼 라이선스로 제공됩니다. 자세한 내용은 [LICENSE-APACHE](LICENSE-APACHE)와 [LICENSE-MIT](LICENSE-MIT) 파일을 참조하세요.
